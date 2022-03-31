//
//  TableRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/2/24.
//

import UIKit
// 自定义cell
open class TableRow<Cell: ConfigurableCell>: Row, RowConfigurable {
    
    public init(_ data: Cell.CellData) {
        self.item = .constant(data)
    }
    
    public init(_ binding: Binding<Cell.CellData>? = nil) {
        self.item = binding
    }
    
    public var item: Binding<Cell.CellData>?
    
    public var isSelectable: Bool = true
    
    /// The type of the table view cell to display the row.
    public let cellType: UITableViewCell.Type = Cell.self
    
    /// Returns the reuse identifier of the table view cell to display the row.
    public var reuseIdentifier: String { Cell.reuseIdentifier }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    public var customize: ((Cell, Cell.CellData) -> Void)?
    
    public var action: RowAction?
    
    public var height: RowHeight?
    
    public var estimatedHeight: RowHeight?
    
    open func configure(_ cell: UITableViewCell) {
        guard let item = item else { return }
        item.append(observer: self) { [weak cell] changed in
            (cell as? Cell)?.configure(with: changed.new)
        }
        
        guard let cell = cell as? Cell else { return }
        customize?(cell, item.wrappedValue)
    }
    
    open func recovery(_ cell: UITableViewCell) {
        item?.remove(observer: self)
    }
    
    deinit { log("deinit", "TableRow", cellType) }
}

public extension TableRow {
    
    func isSelectable(_ value: Bool) -> Self {
        self.isSelectable = value
        return self
    }
    
    func data(_ data: Cell.CellData) -> Self {
        item = .constant(data)
        return self
    }
    
    func data(_ value: Binding<Cell.CellData>) -> Self {
        item = value
        return self
    }
    
    func customize(_ value: @escaping (Cell, Cell.CellData) -> Void) -> Self {
        customize = value
        return self
    }
    
    func customize(_ value: @escaping (Cell) -> Void) -> Self {
        customize = { (cell, _) in value(cell) }
        return self
    }
}
