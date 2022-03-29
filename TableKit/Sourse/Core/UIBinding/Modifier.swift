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
        var mutatingSelf = self
        let issuedIdentifier = Identifier.next()
        mutatingSelf.taskIdentifier = issuedIdentifier
        binding?.add(observer: base) { [weak base] change in
            guard issuedIdentifier == self.taskIdentifier else { return }
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
        var mutatingSelf = self
        let issuedIdentifier = Identifier.next()
        mutatingSelf.taskIdentifier = issuedIdentifier
        stateText?.add(observer: base) { [weak base] changed in
            guard issuedIdentifier == self.taskIdentifier else { return }
            base?.text = changed.new
        }
        return self
    }
    
    @discardableResult
    func text(binding stateText: Binding<String?>?) -> Self {
        var mutatingSelf = self
        let issuedIdentifier = Identifier.next()
        mutatingSelf.taskIdentifier = issuedIdentifier
        stateText?.add(observer: base) { [weak base] changed in
            guard issuedIdentifier == self.taskIdentifier else { return }
            base?.text = changed.new
        }
        return self
    }
}

public extension BindingWrapper where Base: UIButton {
    
    @discardableResult
    func text(binding stateText: Binding<String>?, for state: UIControl.State = .normal) -> Self {
        var mutatingSelf = self
        let issuedIdentifier = Identifier.next()
        mutatingSelf.taskIdentifier = issuedIdentifier
        
        stateText?.add(observer: base) { [weak base] changed in
            guard issuedIdentifier == self.taskIdentifier else { return }
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
        var mutatingSelf = self
        let issuedIdentifier = Identifier.next()
        mutatingSelf.taskIdentifier = issuedIdentifier
        
        var shouldObserve = true
        base.editingChanged { new in
            guard issuedIdentifier == self.taskIdentifier else { return }
            
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
        var mutatingSelf = self
        let issuedIdentifier = Identifier.next()
        mutatingSelf.taskIdentifier = issuedIdentifier
        binding?.add(observer: base) { [weak base] changed in
            guard issuedIdentifier == self.taskIdentifier else { return }
            base?.isOn = changed.new
        }
        let _ = base.action(for: .valueChanged) { [weak base] in
            binding?.wrappedValue = base?.isOn ?? false
            toggle(base?.isOn ?? false)
        }
        return self
    }
}

private var taskIdentifierKey: Void?
extension BindingWrapper where Base: UIView {
    
    public private(set) var taskIdentifier: Identifier.Value? {
        get {
            let box: Box<Identifier.Value>? = base.associated.get(&taskIdentifierKey)
            return box?.value
        }
        set {
            let box = newValue.map { Box($0) }
            base.associated.set(retain: &taskIdentifierKey, box)
        }
    }
}

class Box<T> {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
}

public enum Identifier {

    /// The underlying value type of source identifier.
    public typealias Value = UInt
    static var current: Value = 0
    static func next() -> Value {
        current += 1
        return current
    }
}
