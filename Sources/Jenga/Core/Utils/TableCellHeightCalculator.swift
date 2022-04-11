import UIKit

public protocol RowHeightCalculator {
    
    func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    
    func invalidate()
}

open class TableCellHeightCalculator: RowHeightCalculator {
    
    private(set) weak var tableView: UITableView?
    private var prototypes = [String: UITableViewCell]()
    private var cachedHeights = [Int: CGFloat]()
    
    public init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    open func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat {
        guard let tableView = tableView else { return 0 }
        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue ^ indexPath.hashValue
        
        if let height = cachedHeights[hash] {
            log("cachedHeights", height, hash)
            return height
        }
        
        var prototypeCell = prototypes[row.reuseIdentifier]
        if prototypeCell == nil {
            if let row = row as? SystemRow {
                prototypeCell =
                tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier) ??
                row.cellType.init(style: row.cellStyle, reuseIdentifier: row.reuseIdentifier)
                
            } else {

                prototypeCell =
                tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier)
            }
            prototypes[row.reuseIdentifier] = prototypeCell
        }
        
        guard let cell = prototypeCell else { return 0 }
        
        cell.prepareForReuse()
        (row as? RowConfigurable)?.configure(cell)
        /* ======================================================================================= */
        // 计算行高参考: https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
        // insetGrouped
        let insetGroupedWidth = tableView.wrapperView?.frame.width
        // sectionIndex
        var rightSystemViewsWidth = tableView.indexView?.frame.width ?? 0
        if let accessoryView = cell.accessoryView {
            rightSystemViewsWidth += 16 + accessoryView.frame.width
        } else {
            switch cell.accessoryType {
            case .none:                          rightSystemViewsWidth += 0
            case .checkmark:                     rightSystemViewsWidth += 40
            case .detailButton:                  rightSystemViewsWidth += 48
            case .disclosureIndicator:           rightSystemViewsWidth += 34
            case .detailDisclosureButton:        rightSystemViewsWidth += 68
            @unknown default:                    rightSystemViewsWidth += 0
            }
        }

        if (UIScreen.main.scale >= 3 && UIScreen.main.bounds.size.width >= 414) {
            rightSystemViewsWidth += 4
        }
        
        let contentViewWidth = (insetGroupedWidth ?? tableView.frame.width) - rightSystemViewsWidth
        cell.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: cell.bounds.height)
        
        let widthConstraint = NSLayoutConstraint(item: cell.contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: contentViewWidth)
        cell.contentView.addConstraint(widthConstraint)
        var edgeConstraints: [NSLayoutConstraint] = []
        if #available(iOS 10.2, *) {
            widthConstraint.priority = .required - 1
            edgeConstraints = [
                NSLayoutConstraint(item: cell.contentView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: cell.contentView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: cell.contentView, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: cell.contentView, attribute: .right, relatedBy: .equal, toItem: cell, attribute: .right, multiplier: 1.0, constant: 0)
            ]
            cell.addConstraints(edgeConstraints)
        }
        
        var height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        cell.contentView.removeConstraint(widthConstraint)
        if #available(iOS 10.2, *) {
            cell.removeConstraints(edgeConstraints)
        }
        
        if height == 0 {
            height = cell.sizeThatFits(CGSize(width: contentViewWidth, height: 0)).height
        }
        
        height += (tableView.separatorStyle != .none ? 1 / UIScreen.main.scale : 0)
        log("HeightCalculator", height, hash)
        /* ======================================================================================= */
        cachedHeights[hash] = height
        return height
    }
    
    open func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat {
        
        guard let tableView = tableView else { return 0 }
        
        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue ^ indexPath.hashValue
        
        if let height = cachedHeights[hash] {
            return height
        }
        
        if let estimatedHeight = row.estimatedHeight , estimatedHeight > 0 {
            return estimatedHeight
        }
        
        return UITableView.automaticDimension
    }
    
    open func invalidate() {
        cachedHeights.removeAll()
    }
}
