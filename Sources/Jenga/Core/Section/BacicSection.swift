import UIKit

open class BacicSection: Section {
    
    public init(_ rows: [Row] = []) {
        self.rows = rows
    }
    
    open var rows: [Row]
    
    open var header = HeaderFooter.defultHeader
    
    open var footer = HeaderFooter.defultFooter
    
    open var rowHeight: CGFloat?
    
    open var hiddenWithEmpty: Bool = false
    
    deinit { log("deinit", "Section") }
}

internal struct BrickSection: Section {
    
    public var rows: [Row] = []
    
    public var header = HeaderFooter.defultHeader
    
    public var footer = HeaderFooter.defultFooter
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    mutating func append(_ row: Row) {
        rows.append(row)
    }
    
    mutating func append(_ rows: [Row]) {
        self.rows.append(contentsOf: rows)
    }
}
