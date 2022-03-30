//
//  TableKit.swift
//  Zunionv 
//
//  Created by 方林威 on 2022/2/25.
//

import UIKit

public enum JengaProvider { }

extension JengaProvider {
    
    public static var isEnabledLog = true
    
    public static func setup()  {
        UIViewController.swizzled
    }
    
    // 全局样式配置 不配置使用系统样式
    public typealias DefaultCellHandle = (UITableViewCell, _ style: RowSystemable) -> Void
    public typealias TableViewHandle = (CGRect) -> UITableView
    
    internal static var defaultHandle: DefaultCellHandle?
    internal static var autoTable: TableViewHandle = { view(frame: $0) }
    
    public static func `default`(block: @escaping DefaultCellHandle) {
        self.defaultHandle = block
    }
    
    public static func autoTable(block: @escaping TableViewHandle) {
        self.autoTable = block
    }
}

public protocol RowHeightCalculator {
    
    func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    
    func invalidate()
}

extension JengaProvider {
        
    static func view(frame: CGRect) -> UITableView {
        let tableView: UITableView
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: frame, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: frame, style: .grouped)
        }
        return tableView
    }
}

public enum TableRowActionType {
    
    case click
    case clickDelete
    case select
    case deselect
    case willSelect
    case willDeselect
    case willDisplay
    case didEndDisplaying
    case shouldHighlight
    case shouldBeginMultipleSelection
    case didBeginMultipleSelection
    case height
    case canEdit
    case configure
    case canDelete
    case canMove
    case canMoveTo
    case move
    case showContextMenu
    case accessoryButtonTap
    case custom(String)
    
    var key: String {
        
        switch (self) {
        case .custom(let key):
            return key
        default:
            return "_\(self)"
        }
    }
}

//func `deinit`(item: Any...) {
//    let result = "deinit" + item.map { "\($0)" }.joined(separator: "\t")
//    print(result, separator: "\t")
//}
