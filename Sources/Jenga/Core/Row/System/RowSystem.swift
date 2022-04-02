import UIKit

// 系统样式
public protocol RowSystem: Row {
    
    /// The text of the row.
    var text: Binding<Text> { get set }
    /// The detail text of the row.
    var detailText: Binding<DetailText> { get set }
    
    /// The style of the table view cell to display the row.
    var cellStyle: UITableViewCell.CellStyle { get }
    
    /// The icon of the row.
    var icon: Binding<Icon>? { get set }
    
    /// The type of standard accessory view the cell should use.
    var accessoryType: UITableViewCell.AccessoryType { get }
}

public extension RowSystem {
    
    func icon(_ value: Binding<Icon>) -> Self {
        update { $0.icon = value }
    }
    
    func icon(_ value: Icon) -> Self {
        update { $0.icon = .constant(value) }
    }
    
    func detailText(_ value: Binding<DetailText>) -> Self {
        update { $0.detailText = value }
    }
    
    func detailText(_ value: DetailText) -> Self {
        update { $0.detailText = .constant(value) }
    }
    
    func detailText(_ value: String) -> Self {
        update {
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
        return update {
            $0.detailText = value.map { value  in
                temp.type = .value1
                temp.text.string = value
                return temp
            }
        }
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ value: Value) -> Self {
        update { $0.text = text.map { $0.with(keyPath, value) } }
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ value: Value) -> Self {
        update {
            $0.detailText = detailText.map { detailText in
                var temp = detailText
                temp.text = temp.text.with(keyPath, value)
                return temp
            }
        }
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ binding: Binding<Value>) -> Self {
        let temp = text.wrappedValue
        return update { $0.text = binding.map { temp.with(keyPath, $0) } }
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ binding: Binding<Value>) -> Self {
        var temp = detailText.wrappedValue
        return update {
            $0.detailText = binding.map { value  in
                temp.text = temp.text.with(keyPath, value)
                return temp
            }
        }
    }
}

public protocol NavigationRowCompatible: RowSystem {
    
    var accessoryButtonAction: RowAction? { get }
}

public protocol BadgeRowCompatible: RowSystem, AnyObject {
    
    var badgeValue: Binding<String?> { get set }
    var badgeColor: Binding<UIColor>? { get set }
}

public protocol TapActionRowCompatible: RowSystem {
    
    var textAlignment: NSTextAlignment { get set}
}

public protocol OptionRowCompatible: RowSystem, AnyObject {
    
    var isSelected: Bool { get set }
}

public protocol ToggleRowCompatible: RowSystem {
    
    var isOn: Binding<Bool> { get set }
    var onTap: ((Bool) -> Void)? { get }
}
