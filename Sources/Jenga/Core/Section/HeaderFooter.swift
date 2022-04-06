//
//  HeaderFooter.swift
//  Jenga
//
//  Created by 方林威 on 2022/4/1.
//

import UIKit

public enum HeaderFooterModel {
    
    public static var defultHeader: HeaderFooterModel { .clean }

    public static var defultFooter: HeaderFooterModel { .clean }
    
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

public protocol HeaderFooter {
    
    var model: HeaderFooterModel { get set }
    
    var rowHeight: CGFloat? { get set }
    
    var hiddenWithEmpty: Bool { get set }
}

public protocol Header: HeaderFooter { }
public protocol Footer: HeaderFooter { }

public struct TableHeader: Header {
    
    public var model: HeaderFooterModel = .defultHeader
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    public init() {}
    
    public init(_ height: CGFloat) {
        model = .string(nil, height: height)
    }
    
    public init(_ value: @autoclosure () -> (String)) {
        model = .string(value())
    }
    
    public init(_ value: @autoclosure () -> (UIView)) {
        model = .view(value())
    }
    
    public init(_ value: @autoclosure () -> (HeaderFooterModel)) {
        model = value()
    }
}

public struct TableFooter: Footer {
    
    public var model: HeaderFooterModel = .defultFooter
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    public init() {}
    
    public init(_ height: CGFloat) {
        model = .string(nil, height: height)
    }
    
    public init(_ value: @autoclosure () -> (String)) {
        model = .string(value())
    }
    
    public init(_ value: @autoclosure () -> (UIView)) {
        model = .view(value())
    }
    
    public init(_ value: @autoclosure () -> (HeaderFooterModel)) {
        model = value()
    }
}

extension TableHeader: Update { }
extension TableFooter: Update { }

public extension TableHeader {
    
    func height(_ value: @autoclosure () -> (CGFloat)) -> Self {
        update { $0.model.height = value() }
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        update { $0.hiddenWithEmpty = value }
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        update { $0.rowHeight = value() }
    }
}

public extension TableFooter {
    
    func height(_ value: @autoclosure () -> (CGFloat)) -> Self {
        update { $0.model.height = value() }
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        update { $0.hiddenWithEmpty = value }
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        update { $0.rowHeight = value() }
    }
}
