//
//  Section.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/2.
//

import UIKit

public protocol Section: Reform, JengaHashable {
    
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
        reform { $0.header = value() }
    }
    
    func header(_ value: @autoclosure () -> (String)) -> Self {
        reform { $0.header = .string(value()) }
    }
    
    func header(_ value: @autoclosure () -> (UIView)) -> Self {
        reform { $0.header = .view(value()) }
    }
    
    func footer(_ value: @autoclosure () -> (HeaderFooter)) -> Self {
        reform { $0.footer = value() }
    }
    
    func footer(_ value: @autoclosure () -> (String)) -> Self {
        reform { $0.footer = .string(value()) }
    }
    
    func footer(_ value: @autoclosure () -> (UIView)) -> Self {
        reform { $0.footer = .view(value()) }
    }
    
    func headerHeight(_ value: @autoclosure () -> (CGFloat)) -> Self {
        reform { $0.header.height = value() }
    }
    
    func footerHeight(_ value: @autoclosure () -> (CGFloat)) -> Self {
        reform { $0.footer.height = value() }
    }
    
    func hiddenWithEmpty(_ value: Bool) -> Self {
        reform { $0.hiddenWithEmpty = value }
    }
    
    func rowHeight(_ value: @autoclosure () -> (RowHeight)) -> Self {
        reform { $0.rowHeight = value() }
    }
}
