import UIKit

/// A class that represents a row with a switch.
open class ToggleRow<Cell: ToggleCell>: BasicRow<Cell>, ToggleRowCompatible, Equatable {
    
    public init(_ text: Binding<String>, isOn: Binding<Bool>) {
        self.isOn = isOn
        super.init(text)
    }
    
    public init(_ text: String, isOn: Binding<Bool>) {
        self.isOn = isOn
        super.init(text)
    }
    
    public var isOn: Binding<Bool>
    
    public var onTap: ((Bool) -> Void)?
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? Cell)?.configure(with: (isOn, onTap))
    }
    
    public override var isSelectable: Bool {
        get { false }
        set {}
    }
    
    public static func == (lhs: ToggleRow, rhs: ToggleRow) -> Bool {
        return lhs.text == rhs.text &&
        lhs.detailText == rhs.detailText &&
        lhs.isOn == rhs.isOn &&
        lhs.icon == rhs.icon
    }
}

public extension ToggleRow {
    
    func isOn(_ value: Bool) -> Self {
        self.isOn = .constant(value)
        return self
    }
    
    /// Toggle click
    func onTap(_ value: @escaping (Bool) -> Void) -> Self {
        self.onTap = value
        return self
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S, Bool) -> Void) -> Self where S: AnyObject {
        self.onTap = { [weak target] isOn in
            guard let target = target else { return }
            value(target, isOn)
        }
        return self
    }
    
}
