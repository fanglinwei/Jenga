import UIKit

/// A class that represents a row with a switch.
open class ToggleRow<Cell: ToggleCell>: BasicRow<Cell>, ToggleRowCompatible {
    
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
    
    public override var isSelectable: Bool {
        get { false }
        set {}
    }
    
    public override var reuseIdentifier: String {
        Cell.reuseIdentifier + "\(hashValue)"
    }
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? Cell)?.configure(with: (isOn, onTap))
    }
}

public extension ToggleRow {
    
    func isOn(_ value: Bool) -> Self {
        reform { $0.isOn = .constant(value) }
    }
    
    /// Toggle click
    func onTap(_ value: @escaping (Bool) -> Void) -> Self {
        reform { $0.onTap = value }
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S, Bool) -> Void) -> Self where S: AnyObject {
        reform {
            $0.onTap = { [weak target] isOn in
                guard let target = target else { return }
                value(target, isOn)
            }
        }
    }
}
