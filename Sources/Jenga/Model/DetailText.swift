import UIKit

/// An enum that represents a detail text with `UITableViewCell.CellStyle`.
public struct DetailText: Equatable {
    
    var type: `Type` = .none
    var text: Text
    
    public enum `Type` {
        /// Does not show a detail text in `UITableViewCell.CellStyle.default`.
        case none
        /// Shows the detail text in `UITableViewCell.CellStyle.subtitle`.
        case subtitle
        /// Shows the detail text in `UITableViewCell.CellStyle.value1`.
        case value1
        /// Shows the detail text in `UITableViewCell.CellStyle.value2`.
        case value2
    }
    
    /// Returns the corresponding table view cell style.
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
