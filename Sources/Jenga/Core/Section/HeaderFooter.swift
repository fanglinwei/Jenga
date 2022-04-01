//
//  HeaderFooter.swift
//  Jenga
//
//  Created by 方林威 on 2022/4/1.
//

import UIKit

public struct HeaderFooter {
    
    var height: CGFloat?
    var content: Content?
    
    var title: String? {
        switch content {
        case .string(let value):    return value
        case .view:                 return nil
        case .none:                 return nil
        }
    }
    
    var view: UIView? {
        switch content {
        case .string:               return nil
        case .view(let value):      return value
        case .none:                 return nil
        }
    }
    
    enum Content {
        case string(String?)
        case view(UIView?)
    }
    
    public init() {
        self.height = nil
        self.content = nil
    }
}


public protocol Header: AnyObject {
    
    var header: HeaderFooter { get set }
    
    var rowHeight: CGFloat? { get set }
    
    var hiddenWithEmpty: Bool { get set }
}

public protocol Footer: AnyObject {
    
    var footer: HeaderFooter { get set }
    
    var rowHeight: CGFloat? { get set }
    
    var hiddenWithEmpty: Bool { get set }
}

public class TableHeader: Header {
    
    open var header = HeaderFooter()
    
    open var rowHeight: CGFloat?
    
    open var hiddenWithEmpty: Bool = false
    
    public init() { }
    
    public init(_ value: @autoclosure () -> (String?)) {
        header.content = .string(value())
    }

    public init(_ value: @autoclosure () -> (UIView?)) {
        header.content = .view(value())
    }
}

public class TableFooter: Footer {
    
    open var footer = HeaderFooter()
    
    open var rowHeight: CGFloat?
    
    open var hiddenWithEmpty: Bool = false
    
    public init() { }
    
    public init(_ value: @autoclosure () -> (String?)) {
        footer.content = .string(value())
    }

    public init(_ value: @autoclosure () -> (UIView?)) {
        footer.content = .view(value())
    }
}

public extension Header {
    
    func height(_ value: @autoclosure () -> (CGFloat)) -> Self {
        header.height = value()
        return self
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        hiddenWithEmpty = value
        return self
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        rowHeight = value()
        return self
    }
}

public extension Footer {

    func height(_ value: @autoclosure () -> (CGFloat)) -> Self {
        footer.height = value()
        return self
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        hiddenWithEmpty = value
        return self
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        rowHeight = value()
        return self
    }
}
