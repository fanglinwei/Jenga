//
//  TableViewRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/6/13.
//

import UIKit
// 自定义cell
public struct WrapperView<View>: Row, RowConfigurable where View: TableRowView {
    public typealias Cell = WrapperViewRowCell<View>
    public typealias Data = View.Data
    
    public init(_ data: Data) {
        self.item = .constant(data)
    }
    
    public init() {
        self.item = nil
    }
    
    public init(_ binding: Binding<Data>) {
        self.item = binding
    }
    
    public var item: Binding<Data>?
    
    public var isSelectable: Bool = true
    
    /// The type of the table view cell to display the row.
    public let cellType: UITableViewCell.Type = Cell.self
    
    /// Returns the reuse identifier of the table view cell to display the row.
    public var reuseIdentifier: String { String(describing: Cell.self) }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    public var customize: ((View, Data) -> Void)?
    
    public var action: RowAction?
    
    public var height: RowHeight?
    
    public var estimatedHeight: RowHeight?
    
    public var edgeInsets: UIEdgeInsets = .zero
    
    public var hashValue: Int { ObjectIdentifier(_observer).hashValue }
    private let _observer = _Observer()
    private class _Observer { }
    
    public func configure(_ cell: UITableViewCell) {
        item?.append(observer: _observer) { [weak cell] changed in
            (cell as? Cell)?.configure(with: changed.new)
        }
        
        guard let cell = cell as? Cell else { return }
        cell.edgeInsets = edgeInsets
        guard let item = item else { return }
        customize?(cell.view, item.wrappedValue)
    }
    
    public func recovery(_ cell: UITableViewCell) {
        item?.remove(observer: _observer)
    }
}

public extension WrapperView {

    func edgeInsets(_ value: UIEdgeInsets) -> Self {
        reform { $0.edgeInsets = value }
    }
    
    func isSelectable(_ value: Bool) -> Self {
        reform { $0.isSelectable = value }
    }

    func data(_ data: Data) -> Self {
        reform { $0.item = .constant(data) }
    }

    func data(_ value: Binding<Data>) -> Self {
        reform { $0.item = value }
    }

    func customize(_ value: @escaping (View, Data) -> Void) -> Self {
        reform { $0.customize = value }
    }

    func customize(_ value: @escaping (View) -> Void) -> Self {
        reform { $0.customize = { (view, _) in value(view) } }
    }
}

extension WrapperView: Table { }

extension UILabel: TableRowView {
    
    public func configure(with data: TableViewRowData) {
        text = "\(data)"
    }
}

extension UIButton: TableRowView {
    
    public func configure(with data: TableViewRowData) {
        setTitle("\(data)", for: .normal)
    }
}

extension UISwitch: TableRowView {
    
    public func configure(with data: Bool) {
        isOn = data
    }
}

public protocol TableViewRowData {}
extension String: TableViewRowData {}
extension Int: TableViewRowData {}
extension Double: TableViewRowData {}
extension Float: TableViewRowData {}
extension Bool: TableViewRowData {}
