//
//  HeaderFooter.swift
//  Jenga
//
//  Created by 方林威 on 2022/4/1.
//

import UIKit

public struct HeaderFooterModel {
    
    var height: CGFloat?
    var content: Content
    
    var title: String? {
        switch content {
        case .string(let value):     return value
        case .view:                  return nil
        case .clean:                 return nil
        }
    }
    
    var view: UIView? {
        switch content {
        case .string:               return nil
        case .view(let value):      return value
        case .clean:                return nil
        }
    }
    
    enum Content {
        case string(String?)
        case view(UIView?)
        case clean
    }
    
    public init() {
        self.height = nil
        self.content = .string(nil)
    }
    
    public static func height(_ value: CGFloat) -> Self {
        var temp = self.init()
        temp.height = value
        return temp
    }
    
    public static var clean: HeaderFooterModel {
        var temp = self.init()
        temp.height = UITableView.zero
        temp.content = .clean
        return temp
    }
}

public protocol HeaderFooter {
    
    var model: HeaderFooterModel { get set }
    
    var rowHeight: CGFloat? { get set }
    
    var hiddenWithEmpty: Bool { get set }
    
    static var clean: Self { get }
}

public protocol Header: HeaderFooter { }
public protocol Footer: HeaderFooter { }

public struct TableHeader: Header {
    
    public var model = HeaderFooterModel()
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    public static var clean: Self {
        var temp = self.init()
        temp.model = .clean
        return temp
    }
    
    public init() {}
    
    public init(_ height: CGFloat) {
        model = .height(height)
    }
    
    public init(_ value: @autoclosure () -> (String)) {
        model.content = .string(value())
    }
    
    public init(_ value: @autoclosure () -> (UIView)) {
        model.content = .view(value())
    }
}

public struct TableFooter: Footer {
    
    public var model = HeaderFooterModel()
    
    public var rowHeight: CGFloat?
    
    public var hiddenWithEmpty: Bool = false
    
    public static var clean: Self {
        var temp = self.init()
        temp.model = .clean
        return temp
    }
    
    public init() {}
    
    public init(_ height: CGFloat) {
        model = .height(height)
    }
    
    public init(_ value: @autoclosure () -> (String)) {
        model.content = .string(value())
    }
    
    public init(_ value: @autoclosure () -> (UIView)) {
        model.content = .view(value())
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
