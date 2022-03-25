//
//  Configurable.swift
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

public protocol RowConfigurable {
    
    func configure(_ cell: UITableViewCell)
}

public protocol ConfigurableCell: UITableViewCell {
    associatedtype CellData

    func configure(with _: CellData)
}

extension UITableViewCell {
    
    internal func defaultSetUp(with row: RowSystemable) {
        // 绑定标题
        row.text.addObserver(target: self) { [weak self] change in
            guard let self = self else { return }
            let text = change.new

            text.string.map { self.textLabel?.text = $0 }
            text.attributedString.map { self.textLabel?.attributedText = $0 }
            text.color.map { self.textLabel?.textColor = $0 }
            text.font.map { self.textLabel?.font = $0 }
            self.textLabel?.edgeInsets = text.edgeInsets
        }

        // 绑定子标题
        row.detailText.addObserver(target: self) { [weak self] change in
            guard let self = self else { return }
            
            switch change.new.type {
            case .none:
                self.detailTextLabel?.text = nil

            case .subtitle, .value1, .value2:
                change.new.text.string.map { self.detailTextLabel?.text = $0 }
                change.new.text.attributedString.map { self.detailTextLabel?.attributedText = $0 }
                change.new.text.color.map { self.detailTextLabel?.textColor = $0 }
                change.new.text.font.map { self.detailTextLabel?.font = $0 }
                self.detailTextLabel?.edgeInsets = change.new.text.edgeInsets
            }
        }
        // 关联图片
        row.icon?.addObserver(target: self) { [weak self] changed in
            guard let self = self else { return }
            switch changed.new {
            case .image(let value):
                self.imageView?.image = value.image
                self.imageView?.highlightedImage = value.highlightedImage

            case .async(let value):
                self.imageView?.kf.setImage(
                    with: value.source,
                    placeholder: value.placeholder,
                    options: value.options) { [weak self] result in
                        guard let value = result.value else { return }
                        self?.imageView?.image = value.image
                        // https://www.cnblogs.com/lisa090818/p/3508390.html
                        self?.setNeedsLayout()
                    }
            }
        }
        
        accessoryView = nil
        accessoryType = row.accessoryType
    }
}
