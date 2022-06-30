import UIKit

/// TODO: 功能待开发
open class OptionRow<T: UITableViewCell>: BasicRow<T>, OptionRowCompatible, Equatable {
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
    
    public static func == (lhs: OptionRow, rhs: OptionRow) -> Bool {
        return lhs.text == rhs.text &&
        lhs.detailText == rhs.detailText &&
        lhs.isSelected == rhs.isSelected &&
        lhs.icon == rhs.icon
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
        reform { $0.optionRowAction = { value(target) } }
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self where S: AnyObject {
        reform {
            $0.optionRowAction = { [weak target] in
                guard let target = target else { return }
                value(target)
            }
        }
    }
}
