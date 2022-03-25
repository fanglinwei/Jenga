//
//  SystemRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/2/24.
//

import UIKit

open class BasicRow<T: UITableViewCell>: RowSystemable, RowConfigurable {
    
    // MARK: - Initializer
    
    /// Initializes an `OptionRow` with a text, a selection state and an action closure.
    /// The detail text, icon, and the customization closure are optional.
    public init(_ binding: Binding<String>) {
        self.text = binding.map { .init(string: $0) }
    }
    
    public init(_ text: String) {
        self.text = .constant(.init(string: text))
    }
    
    // MARK: - Row
    /// The text of the row.
    public var text: Binding<Text>
    
    /// The detail text of the row.
    public var detailText: Binding<DetailText> = .constant(.none)
    
    public var icon: Binding<Icon>?
    
    /// A closure that will be invoked when the `isSelected` is changed.
    public var action: RowAction?
    
    // MARK: - RowStyle
    
    /// The type of the table view cell to display the row.
    public let cellType: UITableViewCell.Type = T.self
    
    /// Returns the reuse identifier of the table view cell to display the row.
    public var reuseIdentifier: String {
        T.reuseIdentifier + detailText.wrappedValue.style.stringValue
    }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    /// Returns the table view cell style for the specified detail text.
    public var cellStyle: UITableViewCell.CellStyle { detailText.wrappedValue.style }
    
    /// The icon of the row.
    public var height: RowHeight?
    
    public var estimatedHeight: RowHeight?
    
    /// `OptionRow` is always selectable.
    public var isSelectable: Bool = true
    
    /// Returns `.checkmark` when the row is selected, otherwise returns `.none`.
    public var accessoryType: UITableViewCell.AccessoryType = .none
    
    /// Additional customization during cell configuration.
    public var customize: ((T) -> Void)?
    
    open func configure(_ cell: UITableViewCell) {
        DSLTableManager.defaultHandle?(cell, self)
        cell.defaultSetUp(with: self)
        guard let cell = cell as? T else { return }
        customize?(cell)
    }
    
    deinit { log("deinit", "SystemRow", cellType, text.string.wrappedValue ?? text.attributedString.wrappedValue?.string ?? "") }
}

extension BasicRow {
 
    func customize(_ value: @escaping ((T) -> Void)) -> Self {
        customize = value
        return self
    }
}

internal extension UITableViewCell.CellStyle {
    
    var stringValue: String {
        switch self {
        case .default:    return ""
        case .subtitle:   return ".subtitle"
        case .value1:     return ".value1"
        case .value2:     return ".value2"
        @unknown default: return ".default"
        }
    }
}
