//
//  NSObject.Runtime.swift
//  Jenga
//
//  Created by 方林威 on 2022/3/30.
//  Copyright © 2022 LEE. All rights reserved.
//

import Foundation

class AssociatedWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

protocol AssociatedCompatible {
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

    enum Policy {
        case nonatomic
        case atomic
    }

    /// 获取关联值
    func get<T>(_ key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(base, key) as? T
    }

    /// 设置关联值 OBJC_ASSOCIATION_ASSIGN
    @discardableResult
    func set<T>(assign key: UnsafeRawPointer, _ value: T) -> T {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_ASSIGN)
        return value
    }

    /// 设置关联值 OBJC_ASSOCIATION_RETAIN_NONATOMIC / OBJC_ASSOCIATION_RETAIN
    @discardableResult
    func set<T>(retain key: UnsafeRawPointer, _ value: T?, _ policy: Policy = .nonatomic) -> T? {
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
    func set<T>(copy key: UnsafeRawPointer, _ value: T?, _ policy: Policy = .nonatomic) -> T? {
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
