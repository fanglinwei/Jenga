import Foundation
import CoreGraphics

@dynamicMemberLookup
public protocol BindingConvertible {
    
    associatedtype Value
    
    var projectedValue : Binding<Self.Value> { get }
    
    func append(observer target: AnyObject?, changeHandler: @escaping Changed<Value>.Handler)
    func remove(observer target: AnyObject)
    
    subscript<Subject>(dynamicMember path: WritableKeyPath<Self.Value, Subject>) -> Binding<Subject> { get }
    subscript<Subject>(dynamicMember path: KeyPath<Self.Value, Subject>) -> Binding<Subject> { get }
}

public extension BindingConvertible {
    
    subscript<Subject>(dynamicMember path: WritableKeyPath<Self.Value, Subject>) -> Binding<Subject> {
        return Binding<Subject>(
            get: { projectedValue.wrappedValue[keyPath: path] },
            set: { projectedValue.wrappedValue[keyPath: path] = $0 },
            appendObserver: { target, observer in
                append(observer: target) { changed in
                    observer(Changed<Subject>(old: changed.old[keyPath: path], new: changed.new[keyPath: path]))
                }
            },
            removeObserver: remove
        )
    }
    
    subscript<Subject>(dynamicMember path: KeyPath<Self.Value, Subject>) -> Binding<Subject> {
        return Binding<Subject>(
            get: { projectedValue.wrappedValue[keyPath: path] },
            set: { _ in },
            appendObserver: { target, observer in
                append(observer: target) { changed in
                    observer(Changed<Subject>(old: changed.old[keyPath: path], new: changed.new[keyPath: path]))
                }
            },
            removeObserver: remove
        )
    }
}

public extension BindingConvertible {
    
    func zip<T: BindingConvertible>(with rhs: T) -> Binding<( Self.Value, T.Value )> {
        return Binding<(Value, T.Value)>(
            get: { ( projectedValue.wrappedValue, rhs.projectedValue.wrappedValue) },
            set: {
                projectedValue.wrappedValue = $0
                rhs.projectedValue.wrappedValue = $1
            },
            appendObserver: { target, observer in
                var c1: Changed<Value>?
                var c2: Changed<T.Value>?
                func perform() {
                    guard let _c1 = c1, let _c2 = c2 else { return }
                    c1 = nil
                    c2 = nil
                    let changed = Changed<(Value, T.Value)>(old: (_c1.old, _c2.old), new: (_c1.new, _c2.new))
                    observer(changed)
                }
                projectedValue.append(observer: target) { changed in
                    c1 = changed
                    perform()
                }
                rhs.projectedValue.append(observer: target) { changed in
                    c2 = changed
                    perform()
                }
            },
            removeObserver: remove
        )
    }
    
    func map<T>(_ transform: @escaping (Value) -> T) -> Binding<T> {
        return Binding<T>(
            get: { transform(projectedValue.wrappedValue) },
            set: { _ in },
            appendObserver: { target, observer in
                append(observer: target) { changed in
                    observer(Changed<T>(old: transform(changed.old), new: transform(changed.new)))
                }
            },
            removeObserver: { target in
                remove(observer: target)
            }
        )
    }
    
    func map<T>(_ transform: @escaping (Value) -> T, _ back: @escaping (T) -> Value) -> Binding<T> {
        return Binding<T>(
            get: { transform(projectedValue.wrappedValue) },
            set: { projectedValue.wrappedValue = back($0) },
            appendObserver: { target, observer in
                append(observer: target) { changed in
                    observer(Changed<T>(old: transform(changed.old), new: transform(changed.new)))
                }
            },
            removeObserver: remove
        )
    }
    
    func map<T, R>(_ rhs: T, transform: @escaping (Value, T) -> R) -> Binding<R> {
        join(.constant(rhs)).map(transform)
    }
    
    func join<T>(_ rhs: Binding<T>) -> Binding<(Value, T)> {
        return Binding<(Value, T)>(
            get: { (projectedValue.wrappedValue, rhs.wrappedValue) },
            set: {
                projectedValue.wrappedValue = $0
                rhs.projectedValue.wrappedValue = $1
            },
            appendObserver: { target, observer in
                var c1: Changed<Value>?
                var c2: Changed<T>?
                func perform() {
                    guard let c1 = c1, let c2 = c2 else { return }
                    let changed = Changed<(Value, T)>(old: (c1.old, c2.old), new: (c1.new, c2.new))
                    observer(changed)
                }
                append(observer: target) { change in
                    c1 = change
                    perform()
                }
                rhs.append(observer: target) { change in
                    c2 = change
                    perform()
                }
            },
            removeObserver: remove
        )
    }
    
    func join<T, R>(_ rhs: Binding<T>, transform: @escaping (Value, T) -> R) -> Binding<R> {
        join(rhs).map(transform)
    }
    
    func zip<T, R>(_ rhs: Binding<T>, transform: @escaping (Value, T) -> R) -> Binding<R> {
        zip(with: rhs).map(transform)
    }
}

extension Binding: Equatable where Value: Equatable {
    
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
    
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Binding<Bool> {
        return lhs.join(rhs) { ele, ele2 in
            return ele == ele2
        }
    }
    
    public static func == (lhs: Binding<Value>, rhs: Value) -> Binding<Bool> {
        return lhs.map { ele in
            return ele == rhs
        }
    }
    
    public static func != (lhs: Binding<Value>, rhs: Binding<Value>) -> Binding<Bool> {
        return lhs.join(rhs) { ele, ele2 in
            return ele != ele2
        }
    }
    
    public static func != (lhs: Binding<Value>, rhs: Value) -> Binding<Bool> {
        return lhs.map { ele in
            return ele != rhs
        }
    }
}

// MARK: math

extension Binding where Value == CGFloat {
    
    public static func + (lhs: Binding<Value>, rhs: Value) -> Binding<Value> {
        return lhs.map { a in
            return a + rhs
        }
    }
    public static func - (lhs: Binding<Value>, rhs: Value) -> Binding<Value> {
        return lhs.map { a in
            return a - rhs
        }
    }
    public static func * (lhs: Binding<Value>, rhs: Value) -> Binding<Value> {
        return lhs.map { a in
            return a * rhs
        }
    }
    public static func / (lhs: Binding<Value>, rhs: Value) -> Binding<Value> {
        return lhs.map { a in
            return a / rhs
        }
    }
    public static func + (lhs: Binding<Value>, rhs: Binding<Value>) -> Binding<Value> {
        return lhs.join(rhs)  { a, b in
            return a + b
        }
    }
    public static func - (lhs: Binding<Value>, rhs: Binding<Value>) -> Binding<Value> {
        return lhs.join(rhs)  { a, b in
            return a - b
        }
    }
    public static func * (lhs: Binding<Value>, rhs: Binding<Value>) -> Binding<Value> {
        return lhs.join(rhs)  { a, b in
            return a * b
        }
    }
    public static func / (lhs: Binding<Value>, rhs: Binding<Value>) -> Binding<Value> {
        return lhs.join(rhs)  { a, b in
            return a / b
        }
    }
}

public extension Binding where Value: Sequence {
    
    func bindEnumerated() -> Binding<EnumeratedSequence<Value>> {
        return self.map { $0.enumerated() }
    }
}

public extension Binding where Value: Collection {
    
    var isEmpty: Bool {
        wrappedValue.isEmpty
    }
}
