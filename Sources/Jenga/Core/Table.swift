//
//  Table.swift
//  Jenga
//
//  Created by 方林威 on 2022/4/1.
//

import Foundation

public protocol Table { }

extension BacicSection: Table { }
extension TableHeader: Table { }
extension TableFooter: Table { }
extension TableSpacer: Table { }

extension BasicRow: Table { }
extension TableRow: Table { }
