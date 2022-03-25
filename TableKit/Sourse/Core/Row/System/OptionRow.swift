import UIKit

/// TODO: 功能待开发
open class OptionRow<T: UITableViewCell>: BasicRow<T>, OptionRowCompatible, Equatable {
    
    // MARK: - Initializer
    
    /// Initializes an `OptionRow` with a text, a selection state and an action closure.
    /// The detail text, icon, and the customization closure are optional.
    public init(text: Binding<String>, isSelected: Bool = false) {
        super.init(text)
        self.isSelected = isSelected
    }
    
    // MARK: - OptionRowCompatible
    
    /// The state of selection.
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
    
    /// Returns `.checkmark` when the row is selected, otherwise returns `.none`.
    public override var accessoryType: UITableViewCell.AccessoryType {
        get { isSelected ? .checkmark : .none }
        set {}
    }
    
    /// Returns true iff `lhs` and `rhs` have equal titles, detail texts, selection states, and icons.
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
