import UIKit

/// 系统样式
public protocol SystemRow: Row {
    
    /// The text of the row.
    var text: Binding<TextValues> { get set }
    /// The detail text of the row.
    var detailText: Binding<DetailText> { get set }
    
    /// The style of the table view cell to display the row.
    var cellStyle: UITableViewCell.CellStyle { get }
    
    /// The icon of the row.
    var icon: Binding<Icon>? { get set }
    
    /// The type of standard accessory view the cell should use.
    var accessoryType: UITableViewCell.AccessoryType { get }
}

public extension SystemRow {
    
    func icon(_ value: Binding<Icon>) -> Self {
        reform { $0.icon = value }
    }
    
    func icon(_ value: Icon) -> Self {
        reform { $0.icon = .constant(value) }
    }
    
    func detailText(_ value: DetailText) -> Self {
        reform {
            $0.detailText = detailText.map(value) { detailText, value in
                return value
            }
        }
    }
    
    func detailText(_ value: String) -> Self {
        reform {
            $0.detailText = detailText.map(value) { detailText, value in
                var temp = detailText
                temp.type = .value1
                temp.text.string = value
                return temp
            }
        }
    }
    
    func detailText(_ binding: Binding<String>) -> Self {
        reform {
            $0.detailText = detailText.join(binding) { detail, value in
                var temp = detail
                temp.type = .value1
                temp.text.string = value
                return temp
            }
        }
    }
    
    func detailText(_ binding: Binding<DetailText>) -> Self {
        reform {
            $0.detailText = detailText.join(binding) { detail, value in
                return value
            }
        }
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ value: Value) -> Self {
        reform { $0.text = text.map(value) { $0.with(keyPath, $1) } }
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ value: Value) -> Self {
        reform {
            $0.detailText = detailText.map(value) { detailText, value in
                var temp = detailText
                temp.text = temp.text.with(keyPath, value)
                return temp
            }
        }
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ binding: Binding<Value>) -> Self {
        reform {
            $0.text = text.join(binding) { text, value in
                text.with(keyPath, value)
            }
        }
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ binding: Binding<Value>) -> Self {
        reform {
            $0.detailText = detailText.join(binding) { detail, value in
                var temp = detail
                temp.text = temp.text.with(keyPath, value)
                return temp
            }
        }
    }
    
    func detail(_ value: DetailText.`Type`) -> Self {
        reform {
            $0.detailText = detailText.map(value) { detailText, value in
                var temp = detailText
                temp.type = value
                return temp
            }
        }
    }
}

public protocol NavigationRowCompatible: SystemRow {
    
    var accessoryButtonAction: (() -> Void)? { get }
}

public protocol BadgeRowCompatible: SystemRow, AnyObject {
    
    var badgeValue: Binding<String?> { get set }
    var badgeColor: Binding<UIColor>? { get set }
}

public protocol TapActionRowCompatible: SystemRow {
    
    var textAlignment: NSTextAlignment { get set}
}

public protocol OptionRowCompatible: SystemRow, AnyObject {
    
    var isSelected: Bool { get set }
}

public protocol ToggleRowCompatible: SystemRow {
    
    var isOn: Binding<Bool> { get set }
    var onTap: ((Bool) -> Void)? { get }
}
