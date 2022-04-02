//
//  Section.swift
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

public protocol Section: AnyObject, Update {
    
    var rows: [Row] { get set }
    
    var header: HeaderFooter { get set }
    
    var footer: HeaderFooter { get set }
    
    var rowHeight: CGFloat? { get set }
    
    var hiddenWithEmpty: Bool { get set }
}

public extension Section {
    
    var numberOfRows: Int { rows.count }
    
    var isEmpty: Bool { rows.isEmpty }
}

public extension Section {
    
    func header(_ value: @autoclosure () -> (HeaderFooter)) -> Self {
        update { $0.header = value() }
    }
    
    func header(_ value: @autoclosure () -> (String?)) -> Self {
        update { $0.header.content = .string(value()) }
    }

    func header(_ value: @autoclosure () -> (UIView?)) -> Self {
        update { $0.header.content = .view(value()) }
    }
    
    func footer(_ value: @autoclosure () -> (HeaderFooter)) -> Self {
        update { $0.footer = value() }
    }
    
    func footer(_ value: @autoclosure () -> (String?)) -> Self {
        update { $0.footer.content = .string(value()) }
    }
    
    func footer(_ value: @autoclosure () -> (UIView?)) -> Self {
        update { $0.footer.content = .view(value()) }
    }
    
    func headerHeight(_ value: @autoclosure () -> (CGFloat)) -> Self {
        update { $0.header.height = value() }
    }
    
    func footerHeight(_ value: @autoclosure () -> (CGFloat)) -> Self {
        update { $0.footer.height = value() }
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        update { $0.hiddenWithEmpty = value }
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        update { $0.rowHeight = value() }
    }
}
