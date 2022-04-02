//
//  TableCellHeightCalculator.swift
//  Zunion
//
//  Created by 方林威 on 2022/2/25.
//

import UIKit

open class TableCellHeightCalculator: RowHeightCalculator {

    private(set) weak var tableView: UITableView?
    private var prototypes = [String: UITableViewCell]()
    private var cachedHeights = [Int: CGFloat]()
    private var separatorHeight = 1 / UIScreen.main.scale
    
    public init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    open func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat {

        guard let tableView = tableView else { return 0 }
        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue
        if let height = cachedHeights[hash] {
            return height
        }

        var prototypeCell = prototypes[row.reuseIdentifier]
        if prototypeCell == nil {

            prototypeCell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier)
            prototypes[row.reuseIdentifier] = prototypeCell
        }

        guard let cell = prototypeCell else { return 0 }
        
        cell.prepareForReuse()
        (row as? RowConfigurable)?.configure(cell)
        
        cell.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: cell.bounds.height)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        let height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + (tableView.separatorStyle != .none ? separatorHeight : 0)

        cachedHeights[hash] = height

        return height
    }

    open func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat {

        guard let tableView = tableView else { return 0 }
        
        let hash = row.hashValue ^ Int(tableView.bounds.size.width).hashValue

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
