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
    
    func detailText(_ value: Binding<DetailText>) -> Self {
        reform { $0.detailText = value }
    }
    
    func detailText(_ value: DetailText) -> Self {
        reform { $0.detailText = .constant(value) }
    }
    
    func detailText(_ value: String) -> Self {
        reform {
            $0.detailText = detailText.map { detailText in
                var temp = detailText
                temp.type = .value1
                temp.text.string = value
                return temp
            }
        }
    }
    
    func detailText(_ value: Binding<String>) -> Self {
        var temp = detailText.wrappedValue
        return reform {
            $0.detailText = value.map { value  in
                temp.type = .value1
                temp.text.string = value
                return temp
            }
        }
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ value: Value) -> Self {
        reform { $0.text = text.map { $0.with(keyPath, value) } }
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ value: Value) -> Self {
        reform {
            $0.detailText = detailText.map { detailText in
                var temp = detailText
                temp.text = temp.text.with(keyPath, value)
                return temp
            }
        }
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ binding: Binding<Value>) -> Self {
        let temp = text.wrappedValue
        return reform { $0.text = binding.map { temp.with(keyPath, $0) } }
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<TextValues, Value>, _ binding: Binding<Value>) -> Self {
        var temp = detailText.wrappedValue
        return reform {
            $0.detailText = binding.map { value  in
                temp.text = temp.text.with(keyPath, value)
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
