//
//  SpacerRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/7.
//

import UIKit

public struct SpacerRow<T: SpacerCell>: Row {
    
    public let color: UIColor
    
    public init(_ height: RowHeight = 10, color: UIColor = .clear) {
        self.height = height
        self.color = color
        self.estimatedHeight = height
    }
    
    public var action: RowAction?
    
    public let cellType: UITableViewCell.Type = T.self
    
    public var reuseIdentifier: String { T.reuseIdentifier }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    public var cellStyle: UITableViewCell.CellStyle = .default
    
    public var height: RowHeight?
    
    public var estimatedHeight: RowHeight?
    
    public var isSelectable: Bool = false
    
    public var accessoryType: UITableViewCell.AccessoryType = .none
}
