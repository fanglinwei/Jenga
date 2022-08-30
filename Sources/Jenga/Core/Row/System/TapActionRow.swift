import UIKit

open class TapActionRow<T: TapActionCell>: BasicRow<T>, TapActionRowCompatible {

    open var textAlignment: NSTextAlignment = .center
    
    open override var isSelectable: Bool {
        get { action != nil }
        set {}
    }
    
    open override var action: RowAction? {
        get { _disabled ? nil : super.action }
        set { super.action = newValue }
    }

    private var _disabled = false
    open var disabled: Binding<Bool> = .constant(false)
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? T)?.configure(with: self)
        disabled.append(observer: self) { [weak self] changed in
            self?._disabled = changed.new
        }
    }
    
    open override func reset(_ cell: UITableViewCell) {
        super.reset(cell)
        disabled.remove(observer: self)
    }
}

public extension TapActionRow {
    
    func textAlignment(_ value: NSTextAlignment) -> Self {
        reform { $0.textAlignment = value }
    }
    
    func disabled(_ value: Binding<Bool>) -> Self {
        reform { $0.disabled = value }
    }
}
