//
//  SystemRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/2/24.
//

import UIKit

open class BasicRow<T: UITableViewCell>: RowSystemable, RowConfigurable {
    
    // MARK: - Initializer
    
    /// Initializes an `OptionRow` with a text, a selection state and an action closure.
    /// The detail text, icon, and the customization closure are optional.
    public init(_ binding: Binding<String>) {
        self.text = binding.map { .init(string: $0) }
    }
    
    public init(_ text: String) {
        self.text = .constant(.init(string: text))
    }
    
    // MARK: - Row
    /// The text of the row.
    public var text: Binding<Text>
    
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
    
    open func configure(_ cell: UITableViewCell) {
        // 先清理内容 (样式也需要还原 最好扩展一套默认样式的配置 每次赋值前还原到默认样式)
        cell.textLabel?.text = nil
        cell.textLabel?.attributedText = nil
        cell.detailTextLabel?.text = nil
        cell.detailTextLabel?.attributedText = nil
        cell.imageView?.image = nil
        cell.imageView?.highlightedImage = nil
        // 再设置内容
        DSLTableManager.defaultHandle?(cell, self)
        
        defaultSetup(with: cell)
        guard let cell = cell as? T else { return }
        customize?(cell)
    }
    
    deinit { log("deinit", "SystemRow", cellType, text.string.wrappedValue ?? text.attributedString.wrappedValue?.string ?? "") }
}

extension BasicRow {
    
    internal func defaultSetup(with cell: UITableViewCell) {
        // 绑定标题
        text.add(observer: cell) { [weak cell] change in
            guard let cell = cell else { return }
            let text = change.new

            text.string.map { cell.textLabel?.text = $0 }
            text.attributedString.map { cell.textLabel?.attributedText = $0 }
            text.color.map { cell.textLabel?.textColor = $0 }
            text.font.map { cell.textLabel?.font = $0 }
            cell.textLabel?.edgeInsets = text.edgeInsets
        }
        
        // 绑定子标题
        detailText.add(observer: cell) { [weak cell] change in
            guard let cell = cell else { return }
            
            switch change.new.type {
            case .none:
                cell.detailTextLabel?.text = nil

            case .subtitle, .value1, .value2:
                change.new.text.string.map { cell.detailTextLabel?.text = $0 }
                change.new.text.attributedString.map { cell.detailTextLabel?.attributedText = $0 }
                change.new.text.color.map { cell.detailTextLabel?.textColor = $0 }
                change.new.text.font.map { cell.detailTextLabel?.font = $0 }
                cell.detailTextLabel?.edgeInsets = change.new.text.edgeInsets
            }
        }
        
        // 关联图片
        icon?.add(observer: cell) { [weak cell] changed in
            guard let cell = cell else { return }
            switch changed.new {
            case .image(let value):
                cell.imageView?.image = value.image
                cell.imageView?.highlightedImage = value.highlightedImage

            case .async(let value):
                cell.imageView?.kf.setImage(
                    with: value.source,
                    placeholder: value.placeholder,
                    options: value.options
                ) { [weak cell] _ in
                    // https://www.cnblogs.com/lisa090818/p/3508390.html
                    cell?.setNeedsLayout()
                }
            }
        }
        
        cell.accessoryView = nil
        cell.accessoryType = accessoryType
    }
}

extension BasicRow {
 
    func customize(_ value: @escaping ((T) -> Void)) -> Self {
        customize = value
        return self
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
