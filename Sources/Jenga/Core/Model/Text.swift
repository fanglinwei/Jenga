import UIKit

public protocol TextKey {
    
    associatedtype Value
    
    static var defaultValue: Value { get }
    
    static func perform(with label: UILabel?, didChanged value: Value)
}

public struct TextValues: Equatable {
    
    private var options: [OptionsKeys: Any] = [:]
    
    public init() { }
    
    public init(string value: String?) {
        self.string = value
    }
    
    public subscript<T: TextKey>(option type: T.Type) -> T.Value {
        get { options[OptionsKeys(type)] as? T.Value ?? type.defaultValue }
        set { options[OptionsKeys(type)] = newValue }
    }
    
    public func with<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var temp = self
        temp[keyPath: keyPath] = value
        return temp
    }
    
    public static func == (lhs: TextValues, rhs: TextValues) -> Bool {
        lhs.string == rhs.string && lhs.attributedString == rhs.attributedString
    }
    
    internal func perform(_ label: UILabel?) {
        options.forEach { $0.key.perform(with: label, didChanged: $0.value) }
    }
}

private struct OptionsKeys: Hashable {
    
    static func == (lhs: OptionsKeys, rhs: OptionsKeys) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    private let closure: (_ label: UILabel?, _ value: Any) -> Void

    private let identifier: ObjectIdentifier
    
    init<T: TextKey>(_ type: T.Type) {
        self.identifier = ObjectIdentifier(type)
        self.closure = { (label, value) in
            guard let value = value as? T.Value else {
                return
            }
            type.perform(with: label, didChanged: value)
        }
    }
    
    fileprivate func perform<Value>(with label: UILabel?, didChanged textValues: Value) {
        closure(label, textValues)
    }
}


/// values
public extension TextValues {
    
    var string: String? {
        get { self[option: StringKey.self] }
        set { self[option: StringKey.self] = newValue }
    }
    
    var attributedString: NSAttributedString? {
        get { self[option: AttributedStringKey.self] }
        set { self[option: AttributedStringKey.self] = newValue }
    }
    
    var font: UIFont? {
        get { self[option: FontKey.self] }
        set { self[option: FontKey.self] = newValue }
    }
    
    var color: UIColor? {
        get { self[option: TextColorKey.self] }
        set { self[option: TextColorKey.self] = newValue }
    }
    
    var numberOfLines: Int {
        get { self[option: NumberOfLinesKey.self] }
        set { self[option: NumberOfLinesKey.self] = newValue }
    }
}

/// keys
extension TextValues {
    
    private struct StringKey: TextKey {
        static let defaultValue: String? = nil
        static func perform(with label: UILabel?, didChanged value: String?) {
            label?.text = value
        }
    }

    private struct AttributedStringKey: TextKey {
        static let defaultValue: NSAttributedString? = nil
        static func perform(with label: UILabel?, didChanged value: NSAttributedString?) {
            label?.attributedText = value
        }
    }

    private struct FontKey: TextKey {
        static let defaultValue: UIFont? = nil
        static func perform(with label: UILabel?, didChanged value: UIFont?) {
            label?.font = value
        }
    }

    private struct TextColorKey: TextKey {
        static let defaultValue: UIColor? = nil
        static func perform(with label: UILabel?, didChanged value: UIColor?) {
            label?.textColor = value
        }
    }
    
    private struct NumberOfLinesKey: TextKey {
        static let defaultValue: Int = 1
        static func perform(with label: UILabel?, didChanged value: Int) {
            label?.numberOfLines = value
        }
    }
}
