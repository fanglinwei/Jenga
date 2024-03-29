import UIKit

open class NavigationRow<T: UITableViewCell>: BasicRow<T>, NavigationRowCompatible {
        
    private var _accessoryType: UITableViewCell.AccessoryType?
    
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
    
    public var accessoryButtonAction: (() -> Void)?
    
    public override var isSelectable: Bool {
        get { action != nil }
        set {}
    }
}

extension NavigationRow {
    
    public func accessoryButtonAction(_ value: (() -> Void)?) -> Self {
        reform { $0.accessoryButtonAction = value }
    }
    
    public func accessoryType(_ value: UITableViewCell.AccessoryType) -> Self {
        reform { $0._accessoryType = value }
    }
}
