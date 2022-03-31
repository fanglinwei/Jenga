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
        icon = value
        return self
    }
    
    func icon(_ value: Icon) -> Self {
        icon = .constant(value)
        return self
    }
    
    func detailText(_ value: Binding<DetailText>) -> Self {
        detailText = value
        return self
    }
    
    func detailText(_ value: DetailText) -> Self {
        detailText = .constant(value)
        return self
    }
    
    func detailText(_ value: String) -> Self {
        detailText = detailText.map { detailText in
            var temp = detailText
            temp.type = .value1
            temp.text.string = value
            return temp
        }
        return self
    }
    
    func detailText(_ value: Binding<String>) -> Self {
        var temp = detailText.wrappedValue
        detailText = value.map { value  in
            temp.type = .value1
            temp.text.string = value
            return temp
        }
        return self
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ value: Value) -> Self {
        text = text.map { $0.with(keyPath, value) }
        return self
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ value: Value) -> Self {
        detailText = detailText.map { detailText in
            var temp = detailText
            temp.text = temp.text.with(keyPath, value)
            return temp
        }
        return self
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ binding: Binding<Value>) -> Self {
        let temp = text.wrappedValue
        text = binding.map { temp.with(keyPath, $0) }
        return self
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ binding: Binding<Value>) -> Self {
        var temp = detailText.wrappedValue
        detailText = binding.map { value  in
            temp.text = temp.text.with(keyPath, value)
            return temp
        }
        return self
    }
}

public protocol NavigationRowCompatible: RowSystem {

    var accessoryButtonAction: RowAction? { get }
}

public protocol BadgeRowCompatible: RowSystem {

    var badgeValue: Binding<String?> { get set }
    var badgeColor: Binding<UIColor>? { get set }
}

public protocol TapActionRowCompatible: RowSystem {
    
    var textAlignment: NSTextAlignment { get set}
}

public protocol OptionRowCompatible: RowSystem {
    
    var isSelected: Bool { get set }
}

public protocol ToggleRowCompatible: RowSystem {
    
    var isOn: Binding<Bool> { get set }
    var onTap: ((Bool) -> Void)? { get }
}
