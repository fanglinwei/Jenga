import Foundation
import UIKit

public struct BindingWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol BindingCompatible: AnyObject { }

public protocol BindingCompatibleValue {}
extension UISwitch: BindingCompatible { }
extension UILabel: BindingCompatible { }
extension UITextField: BindingCompatible { }

extension BindingCompatible {
    
    public var binding: BindingWrapper<Self> {
        get { BindingWrapper(self) }
        set { }
    }
}

extension BindingCompatibleValue {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var binding: BindingWrapper<Self> {
        get { return BindingWrapper(self) }
        set { }
    }
}

public extension BindingWrapper where Base: UIView {
    
    @discardableResult
    func with<Value>(_ keyPath: WritableKeyPath<Base, Value>, binding: Binding<Value>?) -> Self {
        binding?.add(observer: base) { [weak base] change in
            base?[keyPath: keyPath] = change.new
        }
        return self
    }
    
    @discardableResult
    func with<Value>(_ keyPath: WritableKeyPath<Base, Value>, value newValue: Value) -> Self {
        var weakBase = base as Base?
        weakBase?[keyPath: keyPath] = newValue
        return self
    }
}

/// UIControl.Event
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

public extension BindingWrapper where Base: UILabel {
    
    @discardableResult
    func text(binding stateText: Binding<String>?) -> Self {
        stateText?.add(observer: base) { [weak base] changed in
            base?.text = changed.new
        }
        return self
    }
    
    @discardableResult
    func text(binding stateText: Binding<String?>?) -> Self {
        stateText?.add(observer: base) { [weak base] changed in
            base?.text = changed.new
        }
        return self
    }
}

public extension BindingWrapper where Base: UIButton {
    
    @discardableResult
    func text(binding stateText: Binding<String>?, for state: UIControl.State = .normal) -> Self {
        stateText?.add(observer: base) { [weak base] changed in
            base?.setTitle(changed.new, for: state)
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
    func selfTextDidChanged() {
        zk_textBlock?(text ?? "")
    }
    
    func editingChanged(change: @escaping (String) -> Void) {
        self.addTarget(self, action: #selector(selfTextDidChanged), for: .editingChanged)
        zk_textBlock = change
    }
}

public extension BindingWrapper where Base: UITextField {
    
    @discardableResult
    func text(binding: Binding<String>?, changed: @escaping (String) -> Void) -> Self {
        var shouldObserve = true
        base.editingChanged { new in
            shouldObserve = false
            changed(new)
            shouldObserve = true
        }
        binding?.add(observer: base) { [weak base] changed in
            guard shouldObserve else { return }
            base?.text = changed.new
            binding?.wrappedValue = changed.new
        }
        return self
    }
}

extension BindingWrapper where Base: UISwitch {
    
    @discardableResult
    func isOn(binding: Binding<Bool>?, toggle: @escaping (Bool) -> Void) -> Self {
        binding?.add(observer: base) { [weak base] changed in
            base?.isOn = changed.new
            print("UISwitch=======", self)
        }
        let _ = base.action(for: .valueChanged) { [weak base] in
            binding?.wrappedValue = base?.isOn ?? false
            toggle(base?.isOn ?? false)
        }
        return self
    }
}
