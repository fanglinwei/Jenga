import Foundation

@propertyWrapper
public struct State<Value>: BindingConvertible {
    internal var location: AnyLocation<Value>
    
    public init(wrappedValue value: Value) {
        self.location = .init(value: value)
    }
    
    public init(initialValue value: Value) {
        self.location = .init(value: value)
    }
    
    public var wrappedValue: Value {
        get { location.value }
        nonmutating set {
            let old = location.value
            location.value = newValue
            observer.send(Changed(old: old, new: newValue))
        }
    }
    
    private let observer = ObserverTargetActions()
    
    public var projectedValue: Binding<Value> {
        Binding(get: { location.value }, set: { location.value = $0 }, appendObserver: addObserver)
    }
    
    public func addObserver(target: AnyObject?, observer: @escaping Changed<Value>.ObserverHandler) {
        let value = location.value
        let changed = Changed(old: value, new: value)
        self.observer.addObserver(changed, target: target, observer: observer)
    }
}

extension State {
    
    class ObserverTargetActions {
        
        private class Action {
            weak var target: AnyObject? 
            var action: Changed<Value>.ObserverHandler
            init(target: AnyObject, action: @escaping Changed<Value>.ObserverHandler) {
                self.target = target
                self.action = action
            }
        }
        
        private var observers: [Action] = []
        
        func addObserver(_ changed: Changed<Value>, target: AnyObject?, observer: @escaping Changed<Value>.ObserverHandler) {
            removeAnyExpiredObservers()
            guard let target = target else { return }
            observers.append(.init(target: target, action: observer))
            observer(changed)
        }
        
        func send(_ changed: Changed<Value>) {
            // filter && call
            observers = observers.filter { tarObj in
                if tarObj.target == nil {
                    return false
                }
                tarObj.action(changed)
                return true
            }
        }
        
        private func removeAnyExpiredObservers() {
            // filter
            observers = observers.filter { $0.target.isSome }
        }
    }
}

public struct Changed<T> {
    internal typealias ValueGetter = () -> T
    var old: T {
        _oldGetter()
    }
    var new: T {
        _newGetter()
    }
    let _oldGetter: ValueGetter
    let _newGetter: ValueGetter
    init(old: @escaping @autoclosure ValueGetter, new: @escaping @autoclosure ValueGetter) {
        _oldGetter = old
        _newGetter = new
    }
    public typealias ObserverHandler = (Changed) -> Void
}
