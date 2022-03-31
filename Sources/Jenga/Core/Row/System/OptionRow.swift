import UIKit

/// TODO: 功能待开发
open class OptionRow<T: UITableViewCell>: BasicRow<T>, OptionRowCompatible, Equatable {
    
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
                self.action?()
            }
        }
    }
    
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
        self.isSelected = value
        return self
    }
}
