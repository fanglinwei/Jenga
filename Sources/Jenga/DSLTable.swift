//
//  DSLTable.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import Foundation

public protocol DSLTable {
    
    var table: TableDirector { get }
    
    var tableContents: [Sectionable] { get }
    
    func reloadTable()
}

public extension DSLTable {
    
    func reloadTable() {
        table.set(sections: tableContents)
    }
}
