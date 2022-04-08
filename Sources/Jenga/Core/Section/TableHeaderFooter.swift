import UIKit

public enum HeaderFooter {
    
    public static var defultHeader: HeaderFooter { .clean }

    public static var defultFooter: HeaderFooter { .clean }
    
    case string(String?, height: CGFloat? = nil)
    case view(UIView?, height: CGFloat? = nil)
    case clean
    
    var title: String? {
        switch self {
        case let .string(value, _):      return value
        case .view:                      return nil
        case .clean:                     return nil
        }
    }
    
    var view: UIView? {
        switch self {
        case .string:                    return nil
        case let .view(value, _):        return value
        case .clean:                     return nil
        }
    }
    
    var height: CGFloat? {
        get {
            switch self {
            case let .string(_, height):     return height
            case let .view(_, height):       return height
            case .clean:                     return UITableView.zero
            }
        }
        set {
            switch self {
            case let .string(value, _):
                self = .string(value, height: newValue)
            case let .view(value, _):
                self = .view(value, height: newValue)
            case .clean:
                self = .string(nil, height: newValue)
            }
        }
    }
}

public protocol TableHeaderFooter {
    
    var content: HeaderFooter { get set }
    
    var rowHeight: CGFloat? { get set }
    
    var hiddenWithEmpty: Bool { get set }
}

public protocol Header: TableHeaderFooter { }
public protocol Footer: TableHeaderFooter { }

public struct TableHeader: Header {
    
    public var content: HeaderFooter = .defultHeader
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    public init() {}
    
    public init(_ height: CGFloat) {
        content = .string(nil, height: height)
    }
    
    public init(_ value: @autoclosure () -> (String)) {
        content = .string(value())
    }
    
    public init(_ value: @autoclosure () -> (UIView)) {
        content = .view(value())
    }
    
    public init(_ value: @autoclosure () -> (HeaderFooter)) {
        content = value()
    }
}

public struct TableFooter: Footer {
    
    public var content: HeaderFooter = .defultFooter
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    public init() {}
    
    public init(_ height: CGFloat) {
        content = .string(nil, height: height)
    }
    
    public init(_ value: @autoclosure () -> (String)) {
        content = .string(value())
    }
    
    public init(_ value: @autoclosure () -> (UIView)) {
        content = .view(value())
    }
    
    public init(_ value: @autoclosure () -> (HeaderFooter)) {
        content = value()
    }
}

extension TableHeader: Reform { }
extension TableFooter: Reform { }

public extension TableHeader {
    
    func height(_ value: @autoclosure () -> (CGFloat)) -> Self {
        reform { $0.content.height = value() }
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        reform { $0.hiddenWithEmpty = value }
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        reform { $0.rowHeight = value() }
    }
}

public extension TableFooter {
    
    func height(_ value: @autoclosure () -> (CGFloat)) -> Self {
        reform { $0.content.height = value() }
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        reform { $0.hiddenWithEmpty = value }
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        reform { $0.rowHeight = value() }
    }
}
