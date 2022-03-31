import Foundation
import UIKit

open class TableSection: BacicSection {
    
    public var didUpdate: ((TableSection) -> Void)?
    
    public init() {
        super.init()
    }
    
    public init(@RowBuilder builder: RowBuilder.ContentBlock) {
        super.init(builder())
    }
    
    public init<T>(_ array: [T], content: @escaping (Binding<T>) -> Row) {
        super.init(array.map { content(.constant($0)) })
    }
}

public extension TableSection {
    
    /// forEach
    convenience init<T>(binding: Binding<[T]>, builder: @escaping (Binding<T>) -> Row) {
        self.init()
        binding.append(observer: self) { [weak self] changed in
            guard let self = self else { return }
            self.rows = changed.new.map { builder(.constant($0)) }
            self.didUpdate?(self)
        }
    }
    
    /// forEach on target
    convenience init<T, S: AnyObject>(
        binding: Binding<[T]>,
        on target: S,
        builder: @escaping (S, Binding<T>) -> Row) {
            self.init()
            binding.append(observer: self) { [weak self, weak target] changed in
                guard let self = self else { return }
                guard let target = target else { return }
                self.rows = changed.new.map { builder(target, .constant($0)) }
                self.didUpdate?(self)
            }
        }
    
    /// map T
    convenience init<T>(binding: Binding<T>, @RowBuilder builder: @escaping (T) -> [Row]) {
        self.init()
        binding.append(observer: self) { [weak self] changed in
            guard let self = self else { return }
            self.rows = builder(changed.new)
            self.didUpdate?(self)
        }
    }
    
    /// map T on target
    convenience init<T, S>(
        binding: Binding<T>,
        on target: S,
        @RowBuilder builder: @escaping (S, T) -> [Row]) where S: AnyObject {
            self.init()
            binding.append(observer: self) { [weak self, weak target] changed in
                guard let self = self else { return }
                guard let target = target else { return }
                self.rows = builder(target, changed.new)
                self.didUpdate?(self)
            }
        }
    
    /// map  binding EnumeratedSequence
    convenience init<T>(binding: Binding<EnumeratedSequence<[T]>>,
                        builder: @escaping (Binding<EnumeratedSequence<[T]>.Iterator.Element>) -> Row) {
        self.init()
        binding.append(observer: self) { [weak self] changed in
            guard let self = self else { return }
            self.rows = changed.new.map { builder(.constant($0)) }
            self.didUpdate?(self)
        }
    }
    
    /// map  binding EnumeratedSequence on target
    convenience init<T, S>(
        binding: Binding<EnumeratedSequence<[T]>>,
        on target: S,
        builder: @escaping (S, Binding<EnumeratedSequence<[T]>.Iterator.Element>) -> Row) where S: AnyObject {
            self.init()
            binding.append(observer: self) { [weak self, weak target] changed in
                guard let self = self else { return }
                guard let target = target else { return }
                self.rows = changed.new.map { builder(target, .constant($0)) }
                self.didUpdate?(self)
            }
        }
}

