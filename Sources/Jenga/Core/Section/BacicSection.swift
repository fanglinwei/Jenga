//
//  BacicSection.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/2.
//

import UIKit

open class BacicSection: Section {
    
    public init(_ rows: [Row] = []) {
        self.rows = rows
    }
    
    open var rows: [Row]
    
    open var header = HeaderFooterModel.defultHeader
    
    open var footer = HeaderFooterModel.defultFooter
    
    open var rowHeight: CGFloat?
    
    open var hiddenWithEmpty: Bool = false
    
    deinit { log("deinit", "Section") }
}

internal struct BrickSection: Section {
    
    public var rows: [Row] = []
    
    public var header = HeaderFooterModel.defultHeader
    
    public var footer = HeaderFooterModel.defultFooter
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    mutating func append(_ row: Row) {
        rows.append(row)
    }
    
    mutating func append(_ rows: [Row]) {
        self.rows.append(contentsOf: rows)
    }
}
