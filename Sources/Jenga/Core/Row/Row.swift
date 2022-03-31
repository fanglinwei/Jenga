import UIKit

public protocol RowActionable: AnyObject {
    
    var isSelectable: Bool { get set }
    
    var action: RowAction? { get set }
}

public protocol RowHashable: AnyObject {
    
    var hashValue: Int { get }
}

extension RowHashable {
    
    public var hashValue: Int { ObjectIdentifier(self).hashValue }
}

public protocol Row: RowHashable, RowActionable {
    
    var cellType: UITableViewCell.Type { get }
    
    var reuseIdentifier: String { get }
    
    var selectionStyle: UITableViewCell.SelectionStyle { get set }
    
    var height: RowHeight? { get set }
    
    var estimatedHeight: RowHeight? { get set }
}

public extension Row {
    
    func height(_ value: RowHeight?) -> Self {
        height = value
        return self
    }
    
    func estimatedHeight(_ value: RowHeight?) -> Self {
        estimatedHeight = value
        return self
    }
    
    func selectionStyle(_ value: UITableViewCell.SelectionStyle) -> Self {
        selectionStyle = value
        return self
    }
}

public extension RowActionable {
    
    
    func onTap(_ value: RowAction?) -> Self {
        self.action = value
        return self
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self {
        self.action = { value(target) }
        return self
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self where S: AnyObject {
        self.action = { [weak target]  in
            guard let target = target else { return }
            value(target)
        }
        return self
    }
}

public typealias RowHeight = CGFloat
public typealias RowAction = () -> Void
