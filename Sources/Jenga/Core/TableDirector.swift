//
//  TableDirector.swift
//  TableDirector
//
//  Created by 方林威 on 2022/2/23.
//

import UIKit

public class TableDirector: NSObject {
    public let tableView: UITableView
    
    public private(set) weak var delegate: UIScrollViewDelegate?
    
    private(set) var rowHeightCalculator: RowHeightCalculator?
    
    private var cellRegisterer: TableCellRegisterer?
    
    private var sections: [Section] = [] {
        didSet { tableView.reloadData() }
    }
    
    open var shouldUsePrototypeCellHeightCalculation: Bool = false {
        didSet {
            rowHeightCalculator = shouldUsePrototypeCellHeightCalculation ? TableCellHeightCalculator(tableView: tableView) : nil
        }
    }
    
    public var isEmpty: Bool { sections.isEmpty }
    
    public init(_ tableView: UITableView,
                delegate: UIScrollViewDelegate? = .none,
                isRegisterCell: Bool = true,
                rowheightCalculator: RowHeightCalculator?) {
        self.tableView = tableView
        self.delegate = delegate
        self.rowHeightCalculator = rowheightCalculator
        if isRegisterCell {
            self.cellRegisterer = TableCellRegisterer(tableView: tableView)
        }
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    public convenience init(_ tableView: UITableView,
                            delegate: UIScrollViewDelegate? = .none,
                            isRegisterCell: Bool = true,
                            shouldCellHeightCalculation: Bool = false) {
        let heightCalculator: TableCellHeightCalculator? = shouldCellHeightCalculation ? TableCellHeightCalculator(tableView: tableView) : nil
        
        self.init(tableView,
                  delegate: delegate,
                  isRegisterCell: isRegisterCell,
                  rowheightCalculator: heightCalculator
        )
    }
    
    private var tableBody: [Table]?
    public func setup(_ tableBody: [Table]) {
        self.tableBody = tableBody
        
        self.sections = assemble(with: tableBody) .filter { !($0.isEmpty && $0.hiddenWithEmpty) }
        reload()
        
        weak var `self` = self
        func reloadAll() {
            self?.setup(self?.tableBody ?? [])
        }
        
        func reloadSection(_ section: Section) {
            guard let self = self else { return }
            guard let index = self.sections.firstIndex(where: { $0 === section }) else { return }
            UIView.performWithoutAnimation {
                self.tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
        
        sections.forEach {
            guard let section = $0 as? TableSection  else { return }
            let old = section.isEmpty && section.hiddenWithEmpty
            section.didUpdate = { section in
                let new = section.isEmpty && section.hiddenWithEmpty
                old == new ? reloadSection(section) : reloadAll()
            }
        }
    }
    
    public func reload() {
        tableView.reloadData()
    }
    
    public override func responds(to selector: Selector) -> Bool {
        return super.responds(to: selector) || delegate?.responds(to: selector) == true
    }
    
    public override func forwardingTarget(for selector: Selector) -> Any? {
        return delegate?.responds(to: selector) == true ? delegate : super.forwardingTarget(for: selector)
    }
    
    deinit { log("deinit", classForCoder) }
}

extension TableDirector {
    
    private func assemble(with tableBody: [Table]) -> [Section] {
        var result: [Section] = []
        var section: BrickSection?
        for (index, body) in tableBody.enumerated() {
            switch body {
            case let value as Section:
                result.append(value)
                
            case let value as Header:
                if let temp = section {
                    result.append(temp)
                    section = nil
                }
                
                section = BrickSection()
                section?.header = value.header
                section?.rowHeight = value.rowHeight
                section?.hiddenWithEmpty = value.hiddenWithEmpty
                
            case let value as Footer:
                let temp = section ?? BrickSection()
                temp.footer = value.footer
                temp.rowHeight = value.rowHeight
                temp.hiddenWithEmpty = value.hiddenWithEmpty
                result.append(temp)
                section = nil
                
            case let value as Row:
                let temp = section ?? BrickSection()
                temp.append(value)
                section = temp
                
                if index == tableBody.count - 1 {
                    result.append(temp)
                    section = nil
                }
                
            default:
                break
            }
        }
        return result
    }
}

extension TableDirector: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        func cell(for row: Row) -> UITableViewCell {
            if let row = row as? RowSystem {
                let cell =
                tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier) ??
                row.cellType.init(style: row.cellStyle, reuseIdentifier: row.reuseIdentifier)
                (row as? RowConfigurable)?.configure(cell)
                cell.selectionStyle = row.selectionStyle
                return cell
                
            } else {
                cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
                
                let cell =
                tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
                (row as? RowConfigurable)?.configure(cell)
                cell.selectionStyle = row.selectionStyle
                return cell
            }
        }
        
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        return cell(for: row)
    }
}

extension TableDirector: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = sections[safe: indexPath.section]?.rows[safe: indexPath.row]
        (row as? RowConfigurable)?.recovery(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch (section, row) {
        case let (radio as RadioSection, option as OptionRowCompatible):
            let changes: [IndexPath] = radio.toggle(option).map {
                IndexPath(row: $0, section: indexPath.section)
            }
            if changes.isEmpty {
                tableView.deselectRow(at: indexPath, animated: false)
            } else {
                tableView.reloadRows(at: changes, with: .automatic)
            }
            
        case let (_, option as OptionRowCompatible):
            option.isSelected = !option.isSelected
            tableView.reloadData()
            
        case (_, is TapActionRowCompatible):
            tableView.deselectRow(at: indexPath, animated: true)
            DispatchQueue.main.async {
                row.action?()
            }
            
        case let (_, row) where row.isSelectable:
            DispatchQueue.main.async {
                row.action?()
            }
            
        default:
            break
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        if !(row is RowSystem), rowHeightCalculator != nil {
            cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
        }

        return row.height
        ?? row.estimatedHeight
        ?? rowHeightCalculator?.estimatedHeight(forRow: row, at: indexPath)
        ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        if !(row is RowSystem), rowHeightCalculator != nil {
            cellRegisterer?.register(cellType: row.cellType, forCellReuseIdentifier: row.reuseIdentifier)
       }
        
        return row.height
        ?? section.rowHeight
        ?? rowHeightCalculator?.height(forRow: row, at: indexPath)
        ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let header = sections[section].header
        return header.height
            ?? header.view?.frame.size.height
            ?? (header.title.isNilOrEmpty ? UITableView.zero : nil)
            ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footer = sections[section].footer
        return footer.height
            ?? footer.view?.frame.size.height
            ?? (footer.title.isNilOrEmpty ? UITableView.zero : nil)
            ?? UITableView.automaticDimension
    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header.title
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer.title
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].header.view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footer.view
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].rows[indexPath.row].isSelectable
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        switch row {
        case let aavigation as NavigationRowCompatible:
            DispatchQueue.main.async {
                aavigation.accessoryButtonAction?()
            }
        default:
            break
        }
    }
}
