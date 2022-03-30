import UIKit

/// A class that represents a row that triggers certain action when selected.
open class TapActionRow<T: TapActionCell>: BasicRow<T>, TapActionRowCompatible, Equatable {

    /// The `NavigationRow` is selectable when action is not nil.
    public override var isSelectable: Bool {
        get { action != nil }
        set {}
    }
    
    public var textAlignment: NSTextAlignment = .center
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? T)?.configure(with: self)
    }
    
    /// Returns true iff `lhs` and `rhs` have equal titles and detail texts.
    public static func == (lhs: TapActionRow, rhs: TapActionRow) -> Bool {
        return lhs.text == rhs.text && lhs.detailText == rhs.detailText
    }
}

public extension TapActionRow {
    
    func textAlignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }
}
