//
//  UILabel.Inset.swift
//  Jenga
//
//  Created by 方林威 on 2022/3/30.
//  Copyright © 2022 LEE. All rights reserved.
//

import UIKit

extension UILabel {
    
    var edgeInsets: UIEdgeInsets {
        get {
            let wrapper: Wrapper<UIEdgeInsets>? = get(&AssociateKey.edgeInsets)
            return wrapper?.value ?? .zero
        }
        set {
            let wrapper = Wrapper(newValue)
            set(retain: &AssociateKey.edgeInsets, wrapper)
            UILabel.swizzled
        }
    }
    
    @objc
    private func jenga_textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = jenga_textRect(forBounds: bounds.inset(by: edgeInsets), limitedToNumberOfLines: numberOfLines)
        // 根据edgeInsets, 修改绘制文字的bounds
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width += edgeInsets.left + edgeInsets.right
        rect.size.height += edgeInsets.top + edgeInsets.bottom
        return rect
    }
    
    @objc
    private func jenga_drawText(in rect: CGRect) {
        jenga_drawText(in: rect.inset(by: edgeInsets))
    }
}

extension UILabel {
    
    private struct AssociateKey {
        static var edgeInsets: Void?
    }
    
    private class Wrapper<T> {
        let value: T?
        init(_ value: T?) {
            self.value = value
        }
    }
    
    private static let swizzled: Void = {
        do {
            let originalSelector = #selector(UILabel.textRect)
            let swizzledSelector = #selector(UILabel.jenga_textRect)
            swizzled_method(originalSelector, swizzledSelector)
        }
        
        do {
            let originalSelector = #selector(UILabel.drawText)
            let swizzledSelector = #selector(UILabel.jenga_drawText)
            swizzled_method(originalSelector, swizzledSelector)
        }
    }()
}
