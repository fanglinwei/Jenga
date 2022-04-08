import Foundation

public struct Binding<Value>: BindingConvertible {
   
    public typealias AppendObserver = (_ target: AnyObject?, _ changeHandler: @escaping Changed<Value>.Handler) -> Void
    public typealias RemoveObserver = (AnyObject) -> Void
    
    internal var location: AnyLocation<Value>

    private var setter: (Value) -> Void
    private let appendObserver: AppendObserver?
    private let removeObserver: RemoveObserver?
    
    public var wrappedValue: Value {
        get { location.value  }
        nonmutating set {
            location.value = newValue
            setter(newValue)
        }
    }
    
    public var projectedValue: Binding<Value> { self }
    
    public init(get: @escaping () -> Value,
                set: @escaping (Value) -> Void,
                appendObserver: AppendObserver? = nil,
                removeObserver: RemoveObserver? = nil) {
        self.location = .init(value: get())
        self.setter = set
        self.appendObserver = appendObserver
        self.removeObserver = removeObserver
    }
    
    public func append(observer target: AnyObject?, changeHandler: @escaping Changed<Value>.Handler) {
        appendObserver?(target, changeHandler)
    }
    
    public func remove(observer target: AnyObject) {
        removeObserver?(target)
    }
    
    public static func constant(_ value: Value) -> Binding<Value> {
//        return State(wrappedValue: value).projectedValue
        return Binding<Value>(get: { value },
                              set: {_ in }) { target, observer in
            observer(Changed(old: value, new: value))
        }
    }
}

extension Binding: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "\(wrappedValue)"
    }
    
    public var debugDescription: String {
        return "\(wrappedValue)"
    }
}

extension Binding: Sequence where Value: MutableCollection, Value.Index: Hashable {

    public typealias Element     = Binding<Value.Element>
    public typealias Iterator    = IndexingIterator<Binding<Value>>
    public typealias SubSequence = Slice<Binding<Value>>
}

extension Binding: Collection where Value: MutableCollection, Value.Index: Hashable {
    public typealias Index   = Value.Index
    public typealias Indices = Value.Indices
    
    public var startIndex : Value.Index   { return wrappedValue.startIndex }
    public var endIndex   : Value.Index   { return wrappedValue.endIndex   }
    public var indices    : Value.Indices { return wrappedValue.indices    }
    
    public func index(after i: Value.Index) -> Value.Index {
        return wrappedValue.index(after: i)
    }
    public func formIndex(after i: inout Value.Index) {
        return wrappedValue.formIndex(after: &i)
    }
    
    public subscript(_ index: Value.Index) -> Binding<Value.Element> {
        return Binding<Value.Element>(
            get: { wrappedValue[index] },
            set: { wrappedValue[index] = $0 },
            appendObserver: { target, observer in
                append(observer: target) { changed in
                    observer(Changed<Value.Element>(old: changed.old[index], new: changed.new[index]))
                }
            },
            removeObserver: remove
        )
    }
}
