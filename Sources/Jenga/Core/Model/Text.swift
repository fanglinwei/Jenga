//
//  Text.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import UIKit

public protocol TextKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

public struct TextValues: Equatable {
    
    private var options = [ObjectIdentifier: Any]()
    
    init(string value: String?) {
        self.string = value
    }
    
    public subscript<T: TextKey>(option type: T.Type) -> T.Value {
        get { options[ObjectIdentifier(type)] as? T.Value ?? type.defaultValue }
        set { options[ObjectIdentifier(type)] = newValue }
    }
    
    public func with<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var temp = self
        temp[keyPath: keyPath] = value
        return temp
    }
    
    public static func == (lhs: TextValues, rhs: TextValues) -> Bool {
        lhs.string == rhs.string && lhs.attributedString == rhs.attributedString
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
    }

    private struct AttributedStringKey: TextKey {
        static let defaultValue: NSAttributedString? = nil
    }

    private struct FontKey: TextKey {
        static let defaultValue: UIFont? = nil
    }

    private struct TextColorKey: TextKey {
        static let defaultValue: UIColor? = nil
    }
    
    private struct NumberOfLinesKey: TextKey {
        static let defaultValue: Int = 1
    }
}
