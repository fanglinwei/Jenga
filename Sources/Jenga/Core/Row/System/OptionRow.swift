import UIKit

/// TODO: 功能待开发
open class OptionRow<T: UITableViewCell>: BasicRow<T>, OptionRowCompatible {
    public typealias OptionRowAction = (() -> Void)
    public init(text: Binding<String>, isSelected: Bool = false) {
        super.init(text)
        self.isSelected = isSelected
    }
    
    public var isSelected: Bool = false {
        didSet {
            guard isSelected != oldValue else {
                return
            }
            DispatchQueue.main.async {
                self.optionRowAction?()
            }
        }
    }
    
    public var optionRowAction: OptionRowAction?
    
    public override var accessoryType: UITableViewCell.AccessoryType {
        get { isSelected ? .checkmark : .none }
        set {}
    }
}

public extension OptionRow {
    
    func isSelected(_ value: Bool) -> Self {
        reform { $0.isSelected = value }
    }
    
    func onTap(_ value: OptionRowAction?) -> Self {
        reform { $0.optionRowAction = value }
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self {
        onTap { value(target) }
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self where S: AnyObject {
        onTap { [weak target] in
            guard let target = target else { return }
            value(target)
        }
    }
}
