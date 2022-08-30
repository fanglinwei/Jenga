import UIKit

public protocol RowActionable {
    
    var isSelectable: Bool { get set }
    
    var action: RowAction? { get set }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self where S: AnyObject
}

public protocol Row: JengaHashable, RowActionable, Reform {
    
    var cellType: UITableViewCell.Type { get }
    
    var reuseIdentifier: String { get }
    
    var selectionStyle: UITableViewCell.SelectionStyle { get set }
    
    var height: RowHeight? { get set }
    
    var estimatedHeight: RowHeight? { get set }
}

public extension Row {
      
    func height(_ value: RowHeight?) -> Self {
        reform { $0.height = value }
    }
    
    func height(_ value: @autoclosure () -> (CGFloat)) -> Self {
        reform { $0.height = .constant(value()) }
    }
    
    func estimatedHeight(_ value: RowHeight?) -> Self {
        reform { $0.estimatedHeight = value }
    }
    
    func selectionStyle(_ value: UITableViewCell.SelectionStyle) -> Self {
        reform { $0.selectionStyle = value }
    }
    
    func onTap(_ value: @escaping (() -> Void)) -> Self {
        reform { $0.action = { _ in value() } }
    }

    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self {
        onTap { value(target) }
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S) -> Void) -> Self where S: AnyObject {
        onTap { [weak target] in
            guard let target = target else { return }
            value(target)
        }
    }
}

public enum RowHeight {
    case constant(CGFloat)
    case automaticDimension
    case highAutomaticDimension
    
    public var value: CGFloat {
        switch self {
        case .constant(let cGFloat):            return cGFloat
        case .automaticDimension:               return UITableView.automaticDimension
        case .highAutomaticDimension:           return UITableView.automaticDimension
        }
    }
    
    var isHighAutomaticDimension: Bool {
        switch self {
        case .constant:                        return false
        case .automaticDimension:              return false
        case .highAutomaticDimension:          return true
        }
    }
}

public typealias RowAction = (UITableViewCell) -> Void

