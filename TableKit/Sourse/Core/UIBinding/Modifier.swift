import Foundation
import UIKit

///
///
///摘抄了一些常用属性，修改后返回self，达到链式调用的效果
///
///
///

public protocol KeyPathBinding { }

extension UIView: KeyPathBinding {
}

public extension KeyPathBinding where Self: UIView {
    
    @discardableResult
    func with<Value>(_ keyPath: WritableKeyPath<Self, Value>, binding: Binding<Value>?) -> Self {
        binding?.addObserver(target: self, observer: { [weak self] change in
            self?[keyPath: keyPath] = change.new
        })
        return self
    }
    
    @discardableResult
    func with<Value>(_ keyPath: WritableKeyPath<Self, Value>, value newValue: Value) -> Self {
        // self[keyPath: keyPath] = newValue
        // 收到警告？？？Cannot assign through subscript: 'self' is immutable
        var weakself = self as Self?
        weakself?[keyPath: keyPath] = newValue
        return self
    }
}

fileprivate extension UIControl {
    
    typealias ActionBlock = () -> Void
    
    private enum AssociatedKey {
        static var blockKey: Int = 0
    }
    
    func action(for event: Event = .touchUpInside, _ action: @escaping ActionBlock) -> Self {
        zk_actionBlock = action
        addTarget(self, action: #selector(zk_selfTapAction), for: event)
        return self
    }
    
    private var zk_actionBlock: ActionBlock? {
        set {
            let n = newValue
            objc_setAssociatedObject(self, &AssociatedKey.blockKey, n, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let n = objc_getAssociatedObject(self, &AssociatedKey.blockKey)
            return n as? ActionBlock
        }
    }
    
    @objc
    private func zk_selfTapAction() {
        zk_actionBlock?()
    }
}

public extension UIScrollView {
    
//    func contentOffsetObserve(handler: @escaping (CGPoint) -> Void) -> Self {
//        zk_scrollViewDelegate.scrollDidScrollHandler = handler
//        delegate = zk_scrollViewDelegate
//        return self
//    }
//
//    func pageObserve(handler: @escaping (CGFloat) -> Void) -> Self {
//        return contentOffsetObserve { [weak self] point in
//            if let size = self?.frame.size.width, size > 0 {
//                let page = point.x / size
//                handler(page)
//            }
//        }
//    }
}
// MARK: State Observing

public extension UILabel {
    
    @discardableResult
    func text(binding stateText: Binding<String>?) -> Self {
        stateText?.addObserver(target: self) { [weak self] changed in
            self?.text = changed.new
        }
        return self
    }
    
    @discardableResult
    func text(binding stateText: Binding<String?>?) -> Self {
        stateText?.addObserver(target: self) { [weak self] changed in
            self?.text = changed.new
        }
        return self
    }
}

public extension UIButton {
    
    @discardableResult
    func text(binding stateText: Binding<String>?, for state: UIControl.State = .normal) -> Self {
        stateText?.addObserver(target: self) { [weak self] changed in
            self?.setTitle(changed.new, for: state)
        }
        return self
    }
}

public extension UITextField {
    private typealias EditChangedBlock = (String) -> Void
    
    private enum AssociatedKey {
        static var editKey: Int = 0
    }
    
    private var zk_textBlock: EditChangedBlock? {
        set {
            let n = newValue
            objc_setAssociatedObject(self, &AssociatedKey.editKey, n, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            let n = objc_getAssociatedObject(self, &AssociatedKey.editKey)
            return n as? EditChangedBlock
        }
    }
    
    @objc
    private func selfTextDidChanged() {
        zk_textBlock?(text ?? "")
    }
    
    @discardableResult
    func text(binding text: Binding<String>?, changed: @escaping (String) -> Void) -> Self {
        addTarget(self, action: #selector(selfTextDidChanged), for: .editingChanged)
        var shouldObserve = true
        zk_textBlock = { newText in
            shouldObserve = false
            changed(newText)
            shouldObserve = true
        }
        text?.addObserver(target: self) { [weak self] changed in
            if shouldObserve {
                self?.text = changed.new
            }
        }
        return self
    }
}

public extension UISwitch {
    
    @discardableResult
    func isOn(binding: Binding<Bool>?, toggle: @escaping (Bool) -> Void) -> Self {
        binding?.addObserver(target: self) { [weak self] changed in
            self?.isOn = changed.new
        }
        let _ = self.action(for: .valueChanged) { [weak self] in
            binding?.wrappedValue = self?.isOn ?? false
            toggle(self?.isOn ?? false)
        }
        return self
    }
}
