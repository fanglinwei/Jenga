import UIKit

public protocol DSLTable {
    
    var table: TableDirector { get }
    
    @TableBuilder var tableBody: [Table] { get }
    
    func reloadTable()
    
    func reloadTableHeight(_ animated: Bool)
}

public extension DSLTable {
    
    func reloadTable() {
        table.setup(tableBody)
    }
    
    func reloadTableHeight(_ animated: Bool = false) {
        CATransaction.begin()
        if !animated {
            CATransaction.setDisableActions(true)
        }
        table.tableView.beginUpdates()
        table.tableView.endUpdates()
        CATransaction.commit()
    }
}
