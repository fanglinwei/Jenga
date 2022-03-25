//
//  TableRowAction.swift
//  Zunion
//
//  Created by 方林威 on 2022/2/25.
//

import UIKit

open class TableRowActionOptions<CellType: ConfigurableCell> {

    public let item: CellType.CellData
    public let cell: CellType?
    public let indexPath: IndexPath
    public let userInfo: [AnyHashable: Any]?

    init(item: CellType.CellData, cell: CellType?, path: IndexPath, userInfo: [AnyHashable: Any]?) {

        self.item = item
        self.cell = cell
        self.indexPath = path
        self.userInfo = userInfo
    }
}

private enum TableRowActionHandler<CellType: ConfigurableCell> {

    case voidAction((TableRowActionOptions<CellType>) -> Void)
    case action((TableRowActionOptions<CellType>) -> Any?)

    func invoke(withOptions options: TableRowActionOptions<CellType>) -> Any? {
        
        switch self {
        case .voidAction(let handler):
            return handler(options)
        case .action(let handler):
            return handler(options)
        }
    }
}

open class TableRowAction<CellType: ConfigurableCell> {

    open var id: String?
    public let type: TableRowActionType
    private let handler: TableRowActionHandler<CellType>
    
    public init(_ type: TableRowActionType, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> Void) {

        self.type = type
        self.handler = .voidAction(handler)
    }
    
    public init(_ key: String, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> Void) {
        
        self.type = .custom(key)
        self.handler = .voidAction(handler)
    }
    
    public init<T>(_ type: TableRowActionType, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> T) {

        self.type = type
        self.handler = .action(handler)
    }

    public func invokeActionOn(cell: UITableViewCell?, item: CellType.CellData, path: IndexPath, userInfo: [AnyHashable: Any]?) -> Any? {

        return handler.invoke(withOptions: TableRowActionOptions(item: item, cell: cell as? CellType, path: path, userInfo: userInfo))
    }
}
