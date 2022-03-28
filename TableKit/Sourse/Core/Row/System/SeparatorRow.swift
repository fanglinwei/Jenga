//
//  SeparatorRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/7.
//

import UIKit

/// A class that represents a row that triggers certain navigation when selected.
open class SeparatorRow<T: SeparatorCell>: Row {
    
    let color: UIColor
    
    init(_ height: RowHeight = 10, color: UIColor = .clear) {
        self.height = height
        self.color = color
        self.estimatedHeight = height
    }
    
    public var action: RowAction?
    
    // MARK: - RowStyle
    
    /// The type of the table view cell to display the row.
    public let cellType: UITableViewCell.Type = T.self
    
    /// Returns the reuse identifier of the table view cell to display the row.
    public var reuseIdentifier: String { T.reuseIdentifier }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    /// Returns the table view cell style for the specified detail text.
    public var cellStyle: UITableViewCell.CellStyle = .default
    
    public var height: RowHeight?
    
    public var estimatedHeight: RowHeight?
    
    /// `OptionRow` is always selectable.
    public var isSelectable: Bool = false
    
    /// Returns `.checkmark` when the row is selected, otherwise returns `.none`.
    public var accessoryType: UITableViewCell.AccessoryType = .none
}
