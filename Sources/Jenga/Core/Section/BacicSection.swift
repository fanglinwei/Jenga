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
    
    open var header = HeaderFooter()
    
    open var footer = HeaderFooter()
    
    open var rowHeight: CGFloat?
    
    open var hiddenWithEmpty: Bool = false
    
    deinit { log("deinit", "Section") }
}
