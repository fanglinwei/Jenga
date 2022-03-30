//
//  Sectionable.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/2.
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

public protocol Sectionable: AnyObject {
    
    var rows: [Row] { get set }
    
    var header: HeaderFooter { get set }
    
    var footer: HeaderFooter { get set }
    
    var rowHeight: CGFloat? { get set }
    
    var hiddenWithEmpty: Bool { get set }
}

public extension Sectionable {
    
    var numberOfRows: Int { rows.count }
    
    var isEmpty: Bool { rows.isEmpty }
}

public extension Sectionable {
    
    func header(_ value: @autoclosure () -> (HeaderFooter)) -> Self {
        header = value()
        return self
    }
    
    func header(_ value: @autoclosure () -> (String?)) -> Self {
        header.content = .string(value())
        return self
    }

    func header(_ value: @autoclosure () -> (UIView?)) -> Self {
        header.content = .view(value())
        return self
    }
    
    func footer(_ value: @autoclosure () -> (HeaderFooter)) -> Self {
        footer = value()
        return self
    }
    
    func footer(_ value: @autoclosure () -> (String?)) -> Self {
        footer.content = .string(value())
        return self
    }
    
    func footer(_ value: @autoclosure () -> (UIView?)) -> Self {
        footer.content = .view(value())
        return self
    }
    
    func headerHeight(_ value: @autoclosure () -> (CGFloat)) -> Self {
        header.height = value()
        return self
    }
    
    func footerHeight(_ value: @autoclosure () -> (CGFloat)) -> Self {
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
