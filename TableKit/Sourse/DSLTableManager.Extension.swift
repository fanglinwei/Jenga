//
//  DSLTableManager.Extension.swift
//  DSLTableManager
//
//  Created by 方林威 on 2022/3/23.
//

import UIKit
import Kingfisher

//extension DSLAutoTable where Self: ViewControllerable {
//
//    func didLayoutTable() {
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//}
//
//extension DSLAutoTable where Self: ViewControllerable, Self.Container: BaseNavigationView {
//
//    func didLayoutTable() {
//        view.addSubview(tableView)
//
//        tableView.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalTo(container.navigationBar.snp.bottom)
//        }
//    }
//}
//
//public extension Icon.Image {
//
//    func by(size: CGSize) -> Self {
//        var temp = self
//        temp.image = image?.byResize(to: size)
//        return temp
//    }
//
//    func by(size: CGSize, contentMode: UIView.ContentMode) -> Self {
//        var temp = self
//        temp.image = image?.byResize(to: size, contentMode: contentMode)
//        return temp
//    }
//
//    func by(cornerRadius value: CGFloat? = nil) -> Self {
//        var temp = self
//        temp.image = image?.byRoundedCorners(radius: value)
//        return temp
//    }
//}


// 工具依赖
extension UIView {

    func fillToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
}

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// runtime
import Foundation

public class AssociatedWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

public protocol AssociatedCompatible {
    associatedtype AssociatedCompatibleType
    var associated: AssociatedCompatibleType { get }
}

extension AssociatedCompatible {

    public var associated: AssociatedWrapper<Self> {
        get { return AssociatedWrapper(self) }
    }
}

extension NSObject: AssociatedCompatible { }

extension AssociatedWrapper where Base: NSObject {

    public enum Policy {
        case nonatomic
        case atomic
    }

    /// 获取关联值
    public func get<T>(_ key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(base, key) as? T
    }

    /// 设置关联值 OBJC_ASSOCIATION_ASSIGN
    @discardableResult
    public func set<T>(assign key: UnsafeRawPointer, _ value: T) -> T {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_ASSIGN)
        return value
    }

    /// 设置关联值 OBJC_ASSOCIATION_RETAIN_NONATOMIC / OBJC_ASSOCIATION_RETAIN
    @discardableResult
    public func set<T>(retain key: UnsafeRawPointer, _ value: T?, _ policy: Policy = .nonatomic) -> T? {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
        }
        return value
    }

    /// 设置关联值 OBJC_ASSOCIATION_COPY_NONATOMIC / OBJC_ASSOCIATION_COPY
    @discardableResult
    public func set<T>(copy key: UnsafeRawPointer, _ value: T?, _ policy: Policy = .nonatomic) -> T? {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY)
        }
        return value
    }
}

extension NSObject {

    static func swizzled_method(_ originalSelector: Selector, _ swizzledSelector: Selector) {
        guard
            let originalMethod = class_getInstanceMethod(Self.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(Self.self, swizzledSelector) else {
            return
        }

        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(
            Self.self,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        // 如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(
                Self.self,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )

        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

extension Result {

    public var value: Success? {
        switch self {
        case .success(let value):   return value
        case .failure:              return nil
        }
    }

    public var error: Failure? {
        switch self {
        case .failure(let error):   return error
        case .success:              return nil
        }
    }

    public var isSuccess: Bool {
        switch self {
        case .success:              return true
        case .failure:              return false
        }
    }
}


public extension Optional where Wrapped: Collection {

    /// SwifterSwift: Check if optional is nil or empty collection.
    var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }

    /// SwifterSwift: Returns the collection only if it is not nill and not empty.
    var nonEmpty: Wrapped? {
        guard let collection = self else { return nil }
        guard !collection.isEmpty else { return nil }
        return collection
    }
}

extension Optional {

    /// 可选值为空的时候返回 true
    public var isNone: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }

    /// 可选值非空返回 true
    public var isSome: Bool {
        return !isNone
    }
}

extension UITableView {

    static var zero: CGFloat = 0.001

    func setSectionHeaderTopPadding(_ value: CGFloat) {
        if #available(iOS 15.0, *) { sectionHeaderTopPadding = value }
    }
}

import UIKit

extension UILabel {
    
    public var edgeInsets: UIEdgeInsets {
        get {
            let wrapper: Wrapper<UIEdgeInsets>? = associated.get(&AssociateKey.edgeInsets)
            return wrapper?.value ?? .zero
        }
        set {
            let wrapper = Wrapper(newValue)
            associated.set(retain: &AssociateKey.edgeInsets, wrapper)
            UILabel.swizzled
        }
    }
    
    @objc
    private func _textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = _textRect(forBounds: bounds.inset(by: edgeInsets), limitedToNumberOfLines: numberOfLines)
        // 根据edgeInsets, 修改绘制文字的bounds
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width += edgeInsets.left + edgeInsets.right
        rect.size.height += edgeInsets.top + edgeInsets.bottom
        return rect
    }
    
    @objc
    private func _drawText(in rect: CGRect) {
        _drawText(in: rect.inset(by: edgeInsets))
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
            let originalSelector = #selector(UILabel.textRect(forBounds:limitedToNumberOfLines:))
            let swizzledSelector = #selector(UILabel._textRect(forBounds:limitedToNumberOfLines:))
            swizzled_method(originalSelector, swizzledSelector)
        }
        
        do {
            let originalSelector = #selector(UILabel.drawText(in:))
            let swizzledSelector = #selector(UILabel._drawText(in:))
            swizzled_method(originalSelector, swizzledSelector)
        }
    } ()
}
