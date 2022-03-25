import UIKit

/// A class that represents a row that triggers certain navigation when selected.
open class NavigationRow<T: UITableViewCell>: BasicRow<T>, NavigationRowCompatible, Equatable {
        
    /// A closure that will be invoked when the accessory button is selected.
    public var accessoryButtonAction: RowAction?
    
    /// Returns the accessory type with the disclosure indicator when `action` is not nil,
    /// and with the detail button when `accessoryButtonAction` is not nil.
    public override var accessoryType: UITableViewCell.AccessoryType {
        get {
            if let accessory = _accessoryType { return accessory }
            switch (action, accessoryButtonAction) {
            case (nil, nil):      return .none
            case (.some, nil):    return .disclosureIndicator
            case (nil, .some):    return .detailButton
            case (.some, .some):  return .detailDisclosureButton
            }
        }
        set {}
    }
    
    private var _accessoryType: UITableViewCell.AccessoryType?
    
    /// The `NavigationRow` is selectable when action is not nil.
    public override var isSelectable: Bool {
        get { action != nil }
        set {}
    }
    
    /// Returns true iff `lhs` and `rhs` have equal titles, detail texts and icons.
    public static func == (lhs: NavigationRow, rhs: NavigationRow) -> Bool {
        return lhs.text == rhs.text &&
               lhs.detailText == rhs.detailText &&
               lhs.icon == rhs.icon
    }
}

extension NavigationRow {
    
    public func accessoryButtonAction(_ value: RowAction?) -> Self {
        self.accessoryButtonAction = value
        return self
    }
    
    public func accessoryType(_ value: UITableViewCell.AccessoryType) -> Self {
        _accessoryType = value
        return self
    }
}
