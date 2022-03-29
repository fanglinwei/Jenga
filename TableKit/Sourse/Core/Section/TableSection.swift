import Foundation
import UIKit

open class TableSection: BacicSection {
    
    public var didUpdate: ((TableSection) -> Void)?
    
    public init(@RowBuilder builder: RowBuilder.ContentBlock) {
        super.init(builder())
    }
    
    public init<T>(_ array: [T], content: @escaping (Binding<T>) -> Row) {
        super.init(array.map { content(.constant($0)) })
    }
    
    public init<T>(binding: Binding<[T]>, content: @escaping (Binding<T>) -> Row) {
        super.init()
        binding.append(observer: self) { [weak self] changed in
            guard let self = self else { return }
            self.rows = changed.new.map { content(.constant($0)) }
            self.didUpdate?(self)
        }
    }
    
    public init<T, S: AnyObject>(binding: Binding<[T]>, on target: S, builder: @escaping (S, Binding<T>) -> Row) {
        super.init()
        binding.append(observer: self) { [weak self, weak target] changed in
            guard let self = self else { return }
            guard let target = target else { return }
            self.rows = changed.new.map { builder(target, .constant($0)) }
            self.didUpdate?(self)
        }
    }
    
    public init<T>(binding: Binding<T>, @RowBuilder builder: @escaping (T) -> [Row]) {
        super.init()
        binding.append(observer: self) { [weak self] changed in
            guard let self = self else { return }
            self.rows = builder(changed.new)
            self.didUpdate?(self)
        }
    }
    
    public init<T, S>(binding: Binding<T>, on target: S, @RowBuilder builder: @escaping (S, T) -> [Row]) where S: AnyObject {
        super.init()
        binding.append(observer: self) { [weak self, weak target] changed in
            guard let self = self else { return }
            guard let target = target else { return }
            self.rows = builder(target, changed.new)
            self.didUpdate?(self)
        }
    }
    
    public init<T, S>(binding: Binding<T>, on target: S, @RowBuilder builder: @escaping (S, Binding<T>) -> [Row]) where S: AnyObject {
        super.init()
        binding.append(observer: self) { [weak self, weak target] changed in
            guard let self = self else { return }
            guard let target = target else { return }
            self.rows = builder(target, .constant(changed.new))
            self.didUpdate?(self)
        }
    }
    
    public init<T>(binding: Binding<EnumeratedSequence<[T]>>, content: @escaping (Binding<EnumeratedSequence<[T]>.Iterator.Element>) -> Row) {
        super.init()
        binding.append(observer: self) { [weak self] changed in
            guard let self = self else { return }
            self.rows = changed.new.map { content(.constant($0)) }
            self.didUpdate?(self)
        }
    }
    
    public init<T, S>(binding: Binding<EnumeratedSequence<[T]>>, on target: S, content: @escaping (S, Binding<EnumeratedSequence<[T]>.Iterator.Element>) -> Row) where S: AnyObject {
        super.init()
        binding.append(observer: self) { [weak self, weak target] changed in
            guard let self = self else { return }
            guard let target = target else { return }
            self.rows = changed.new.map { content(target, .constant($0)) }
            self.didUpdate?(self)
        }
    }
}

public typealias RowBuilder = ArrayBuilder<Row>
public typealias SectionBuilder = ArrayBuilder<Sectionable>
public typealias TableBuilder = ArrayBuilder<Sectionable>

