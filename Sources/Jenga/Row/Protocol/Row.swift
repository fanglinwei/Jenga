//
//  Row.swift
//  QuickTableViewController
//
//  Created by Ben on 01/09/2015.
//  Copyright (c) 2015 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import UIKit

public protocol RowActionable: AnyObject {
    
    var isSelectable: Bool { get set }
    
    var action: RowAction? { get set }
}

public protocol RowHashable: AnyObject {
    
    var hashValue: Int { get }
}

extension RowHashable {
    
    public var hashValue: Int { ObjectIdentifier(self).hashValue }
}

/// Any type that conforms to this protocol is capable of representing a row in a table view.
public protocol Row: RowHashable, RowActionable {
    
    /// The type of the table view cell to display the row.
    var cellType: UITableViewCell.Type { get }
    
    /// The reuse identifier of the table view cell to display the row.
    var reuseIdentifier: String { get }
    
    var selectionStyle: UITableViewCell.SelectionStyle { get set }
    
    var height: RowHeight? { get set }
    
    var estimatedHeight: RowHeight? { get set }
}

public extension Row {
    
    func height(_ value: RowHeight?) -> Self {
        height = value
        return self
    }
    
    func estimatedHeight(_ value: RowHeight?) -> Self {
        estimatedHeight = value
        return self
    }
    
    func selectionStyle(_ value: UITableViewCell.SelectionStyle) -> Self {
        selectionStyle = value
        return self
    }
}

public extension RowActionable {
    
    
    func onTap(_ value: RowAction?) -> Self {
        self.action = value
        return self
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self {
        self.action = { value(target) }
        return self
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self where S: AnyObject {
        self.action = { [weak target]  in
            guard let target = target else { return }
            value(target)
        }
        return self
    }
}

public typealias RowHeight = CGFloat
public typealias RowAction = () -> Void
