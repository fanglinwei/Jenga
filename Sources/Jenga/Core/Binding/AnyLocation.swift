import Foundation

internal class AnyLocation<Value> {
   
    private let _value = UnsafeMutablePointer<Value>.allocate(capacity: 1)
    internal var value: Value {
        get { _value.pointee }
        set { _value.pointee = newValue }
    }

    init(value: Value) {
        self._value.initialize(to: value)
    }
}
