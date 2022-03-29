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
        Binding(get: { location.value }, set: { location.value = $0 }, appendObserver: add)
    }
    
    public func add(observer target: AnyObject?, changeHandler: @escaping Changed<Value>.Handler) {
        let value = location.value
        let changed = Changed(old: value, new: value)
        self.observer.add(observer: changed, target: target, changeHandler: changeHandler)
    }
}

extension State {
    
    class ObserverTargetActions {
        
        private class Action: CustomStringConvertible, CustomDebugStringConvertible {
            weak var target: AnyObject?
            var action: Changed<Value>.Handler
            init(target: AnyObject, action: @escaping Changed<Value>.Handler) {
                self.target = target
                self.action = action
            }
            
            var description: String {
                return target.flatMap { "\($0)" } ?? ""
            }
            
            var debugDescription: String {
                return target.flatMap { "\($0)" } ?? ""
            }
        }
        
        private var observers: [Action] = []
        
        func add(observer changed: Changed<Value>, target: AnyObject?, changeHandler: @escaping Changed<Value>.Handler) {
            observers = observers.filter { $0.target.isSome }
            guard let target = target else { return }
            observers.append(.init(target: target, action: changeHandler))
            changeHandler(changed)
            
            print("==================")
            print(observers, self)
        }
        
        func send(_ changed: Changed<Value>) {
            observers = observers.filter { $0.target != nil }
            observers.forEach { $0.action(changed) }
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
    public typealias Handler = (Changed) -> Void
}
