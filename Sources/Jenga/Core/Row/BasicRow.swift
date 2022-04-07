//
//  SystemRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/2/24.
//

import UIKit

open class BasicRow<T: UITableViewCell>: SystemRow, RowConfigurable {
    
    public init(_ binding: Binding<String>) {
        self.text = binding.map { .init(string: $0) }
    }
    
    public init(_ text: String) {
        self.text = .constant(.init(string: text))
    }
    
    // MARK: - Row
    /// The text of the row.
    public var text: Binding<TextValues>
    
    /// The detail text of the row.
    public var detailText: Binding<DetailText> = .constant(.none)
    
    public var icon: Binding<Icon>?
    
    /// A closure that will be invoked when the `isSelected` is changed.
    public var action: RowAction?
    
    // MARK: - RowStyle
    
    /// The type of the table view cell to display the row.
    public let cellType: UITableViewCell.Type = T.self
    
    /// Returns the reuse identifier of the table view cell to display the row.
    public var reuseIdentifier: String {
        T.reuseIdentifier + detailText.wrappedValue.style.stringValue
    }
    
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    /// Returns the table view cell style for the specified detail text.
    public var cellStyle: UITableViewCell.CellStyle { detailText.wrappedValue.style }
    
    /// The icon of the row.
    public var height: RowHeight?
    
    public var estimatedHeight: RowHeight?
    
    /// `OptionRow` is always selectable.
    public var isSelectable: Bool = true
    
    /// Returns `.checkmark` when the row is selected, otherwise returns `.none`.
    public var accessoryType: UITableViewCell.AccessoryType = .none
    
    /// Additional customization during cell configuration.
    public var customize: ((T) -> Void)?
    
    open func reset(_ cell: UITableViewCell) {
        cell.textLabel?.text = nil
        cell.textLabel?.attributedText = nil
        cell.detailTextLabel?.text = nil
        cell.detailTextLabel?.attributedText = nil
        cell.imageView?.image = nil
        cell.imageView?.highlightedImage = nil
    }
    
    open func configure(_ cell: UITableViewCell) {
        // 先清理内容 (样式也需要还原 最好扩展一套默认样式的配置 每次赋值前还原到默认样式)
        reset(cell)
        // 再设置内容
        JengaEnvironment.provider.default(with: cell, self)
        
        defaultSetup(with: cell)
        guard let cell = cell as? T else { return }
        customize?(cell)
    }
    
    open func recovery(_ cell: UITableViewCell) {
        text.remove(observer: self)
        detailText.remove(observer: self)
        icon?.remove(observer: self)
    }
    
    deinit { log("deinit", "SystemRow", cellType, text.string.wrappedValue ?? text.attributedString.wrappedValue?.string ?? "") }
}

public extension BasicRow {
    
    func customize(_ value: @escaping ((T) -> Void)) -> Self {
        reform { $0.customize = value }
    }
}

extension BasicRow {
    
    internal func defaultSetup(with cell: UITableViewCell) {
        // 绑定标题
        text.append(observer: self) { [weak cell] change in
            guard let cell = cell else { return }
            change.new.perform(cell.textLabel)
        }
        
        // 绑定子标题
        detailText.append(observer: self) { [weak cell] change in
            guard let cell = cell else { return }
            
            switch change.new.type {
            case .none:
                cell.detailTextLabel?.text = nil
                
            case .subtitle, .value1, .value2:
                change.new.text.perform(cell.detailTextLabel)
            }
        }
        
        // 关联图片
        icon?.append(observer: self) { [weak cell] changed in
            guard let cell = cell else { return }
            switch changed.new {
            case .image(let value):
                value.loadImage(with: cell.imageView) { [weak cell] result in
                    guard result else { return }
                    // https://www.cnblogs.com/lisa090818/p/3508390.html
                    cell?.setNeedsLayout()
                }
                
            case .async(let value):
                value.loadImage(with: cell.imageView) { [weak cell] result in
                    guard result else { return }
                    // https://www.cnblogs.com/lisa090818/p/3508390.html
                    cell?.setNeedsLayout()
                }
            }
        }
        
        cell.accessoryView = nil
        cell.accessoryType = accessoryType
    }
}

internal extension UITableViewCell.CellStyle {
    
    var stringValue: String {
        switch self {
        case .default:    return ""
        case .subtitle:   return ".subtitle"
        case .value1:     return ".value1"
        case .value2:     return ".value2"
        @unknown default: return ".default"
        }
    }
}
