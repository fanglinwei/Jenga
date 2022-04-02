import UIKit

open class TapActionRow<T: TapActionCell>: BasicRow<T>, TapActionRowCompatible, Equatable {

    public var textAlignment: NSTextAlignment = .center
    
    public override var isSelectable: Bool {
        get { action != nil }
        set {}
    }
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? T)?.configure(with: self)
    }
    
    public static func == (lhs: TapActionRow, rhs: TapActionRow) -> Bool {
        return lhs.text == rhs.text && lhs.detailText == rhs.detailText
    }
}

public extension TapActionRow {
    
    func textAlignment(_ value: NSTextAlignment) -> Self {
        update { $0.textAlignment = value }
    }
}
