import UIKit

public struct SpacerRow<T: SpacerCell>: Row {
    
    public var height: RowHeight?
    
    public let color: UIColor
    
    public var estimatedHeight: RowHeight?
    
    public var isSelectable: Bool = false
    
    public var action: RowAction?
    
    public let cellType: UITableViewCell.Type = T.self
    
    public var reuseIdentifier: String { T.reuseIdentifier }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    public var cellStyle: UITableViewCell.CellStyle = .default
    
    public var accessoryType: UITableViewCell.AccessoryType = .none
    
    public init(_ height: CGFloat = 10, color: UIColor = .clear) {
        self.height = .constant(height)
        self.color = color
        self.estimatedHeight = .constant(height)
    }
}
