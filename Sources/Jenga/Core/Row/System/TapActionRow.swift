import UIKit

open class TapActionRow<T: TapActionCell>: BasicRow<T>, TapActionRowCompatible {

    public var textAlignment: NSTextAlignment = .center
    
    public override var isSelectable: Bool {
        get { action != nil }
        set {}
    }
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? T)?.configure(with: self)
    }
}

public extension TapActionRow {
    
    func textAlignment(_ value: NSTextAlignment) -> Self {
        reform { $0.textAlignment = value }
    }
}
