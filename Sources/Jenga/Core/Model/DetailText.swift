import UIKit

/// An enum that represents a detail text with `UITableViewCell.CellStyle`.
public struct DetailText: Equatable {
    
    var type: `Type` = .none
    var text: TextValues
    
    public enum `Type` {
        case none
        case subtitle
        case value1
        case value2
    }
    
    public var style: UITableViewCell.CellStyle {
        switch type {
        case .none:     return .default
        case .subtitle: return .subtitle
        case .value1:   return .value1
        case .value2:   return .value2
        }
    }
    
    public init(_ type: `Type` = .none, _ string: String? = .none) {
        self.type = type
        self.text = .init(string: string)
    }
}

public extension DetailText {
    
    static var none: DetailText { .init() }
    
    static func subtitle(_ value: String) -> DetailText {
        return .init(.subtitle, value)
    }
    
    static func value1(_ value: String) -> DetailText {
        return .init(.value1, value)
    }
    
    static func value2(_ value: String) -> DetailText {
        return .init(.value2, value)
    }
}
