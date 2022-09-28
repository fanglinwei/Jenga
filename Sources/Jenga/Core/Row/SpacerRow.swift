import UIKit

public struct SpacerRow<Cell: SpacerCell>: Row, RowConfigurable {

    public var height: RowHeight?
    
    public let color: UIColor
    
    public var estimatedHeight: RowHeight?
    
    public var isSelectable: Bool = false
    
    public var action: RowAction?
    
    public let cellType: UITableViewCell.Type = Cell.self
    
    public var reuseIdentifier: String { Cell.reuseIdentifier }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    public var cellStyle: UITableViewCell.CellStyle = .default
    
    public var accessoryType: UITableViewCell.AccessoryType = .none
    
    public init(_ height: CGFloat = 10, color: UIColor = .clear) {
        self.height = .constant(height)
        self.color = color
        self.estimatedHeight = .constant(height)
    }
    
    public func configure(_ cell: UITableViewCell) {
        (cell as? Cell)?.configure(with: color)
    }
    
    public func recovery(_ cell: UITableViewCell) {
        
    }
}
