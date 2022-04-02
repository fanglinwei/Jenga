//
//  TableKit.swift
//  Zunionv 
//
//  Created by 方林威 on 2022/2/25.
//

import UIKit

public typealias RowBuilder = ArrayBuilder<Row>
public typealias TableBuilder = ArrayBuilder<Section>

public enum JengaProvider { }

extension JengaProvider {
    
    public static var isEnabledLog = true
    
    public static func setup()  {
        UIViewController.swizzled
    }
    
    // 全局样式配置 不配置使用系统样式
    public typealias DefaultCellHandle = (UITableViewCell, _ style: RowSystem) -> Void
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
