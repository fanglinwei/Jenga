//
//  RowStyle.swift
//  QuickTableViewController
//
//  Created by Ben on 30/07/2017.
//  Copyright © 2017 bcylin.
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

import UIKit

// 系统样式
public protocol RowSystemable: Row {
    
    /// The text of the row.
    var text: Binding<Text> { get set }
    /// The detail text of the row.
    var detailText: Binding<DetailText> { get set }
    
    /// The style of the table view cell to display the row.
    var cellStyle: UITableViewCell.CellStyle { get }
    
    /// The icon of the row.
    var icon: Binding<Icon>? { get set }
    
    /// The type of standard accessory view the cell should use.
    var accessoryType: UITableViewCell.AccessoryType { get }
}

public extension RowSystemable {
        
    func icon(_ value: Binding<Icon>) -> Self {
        icon = value
        return self
    }
    
    func icon(_ value: Binding<Icon.Image>) -> Self {
        icon = value.map { .image($0) }
        return self
    }
    
    func icon(_ value: Icon) -> Self {
        icon = .constant(value)
        return self
    }
    
    func icon(_ value: Icon.Image) -> Self {
        icon = .constant(.image(value))
        return self
    }
    
    func detailText(_ value: Binding<DetailText>) -> Self {
        detailText = value
        return self
    }
    
    func detailText(_ value: DetailText) -> Self {
        detailText = .constant(value)
        return self
    }
    
    func detailText(_ value: String) -> Self {
        detailText = detailText.map { detailText in
            var temp = detailText
            temp.type = .value1
            temp.text.string = value
            return temp
        }
        return self
    }
    
    func detailText(_ value: Binding<String>) -> Self {
        var temp = detailText.wrappedValue
        detailText = value.map { value  in
            temp.type = .value1
            temp.text.string = value
            return temp
        }
        return self
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ value: Value) -> Self {
        text = text.map { $0.with(keyPath, value) }
        return self
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ value: Value) -> Self {
        detailText = detailText.map { detailText in
            var temp = detailText
            temp.text = temp.text.with(keyPath, value)
            return temp
        }
        return self
    }
    
    func text<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ binding: Binding<Value>) -> Self {
        let temp = text.wrappedValue
        text = binding.map { temp.with(keyPath, $0) }
        return self
    }
    
    func detail<Value>(_ keyPath: WritableKeyPath<Text, Value>, _ binding: Binding<Value>) -> Self {
        var temp = detailText.wrappedValue
        detailText = binding.map { value  in
            temp.text = temp.text.with(keyPath, value)
            return temp
        }
        return self
    }
}
