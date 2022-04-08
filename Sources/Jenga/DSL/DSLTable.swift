import Foundation

public protocol DSLTable {
    
    var table: TableDirector { get }
    
    @TableBuilder var tableBody: [Table] { get }
    
    func reloadTable()
}

public extension DSLTable {
    
    func reloadTable() {
        table.setup(tableBody)
    }
}
