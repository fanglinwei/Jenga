import UIKit
// 自定义cell
public struct TableRow<Cell: ConfigurableCell>: Row, RowConfigurable {
    
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
    
    public var hashValue: Int { ObjectIdentifier(_observer).hashValue }
    private let _observer = _Observer()
    private class _Observer { }
    
    public func configure(_ cell: UITableViewCell) {
        guard let item = item else { return }
        item.append(observer: _observer) { [weak cell] changed in
            (cell as? Cell)?.configure(with: changed.new)
        }
        
        guard let cell = cell as? Cell else { return }
        customize?(cell, item.wrappedValue)
    }
    
    public func recovery(_ cell: UITableViewCell) {
        item?.remove(observer: _observer)
    }
}

public extension TableRow {
    
    func isSelectable(_ value: Bool) -> Self {
        reform { $0.isSelectable = value }
    }
    
    func data(_ data: Cell.CellData) -> Self {
        reform { $0.item = .constant(data) }
    }
    
    func data(_ value: Binding<Cell.CellData>) -> Self {
        reform { $0.item = value }
    }
    
    func customize(_ value: @escaping (Cell, Cell.CellData) -> Void) -> Self {
        reform { $0.customize = value }
    }
    
    func customize(_ value: @escaping (Cell) -> Void) -> Self {
        reform { $0.customize = { (cell, _) in value(cell) } }
    }
}
