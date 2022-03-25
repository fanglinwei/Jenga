import UIKit

// 快速列表使用此协议, 协议都有默认实现 controller 只需要实现tableContents即可
public protocol DSLAutoTable: DSLTable {
    
    var tableView: UITableView { get }
    
    func didLayoutTable()
}

private var TableViewKey: Void?
private var TableKey: Void?
extension DSLAutoTable where Self: UIViewController {

    var tableView: UITableView {
        get {
            guard let value: UITableView = associated.get(&TableViewKey) else {
                let temp = DSLTableManager.view(frame: .zero)
                associated.set(retain: &TableViewKey, temp)
                return temp
            }
            return value
        }
        set { associated.set(retain: &TableViewKey, newValue) }
    }
    
    var table: TableDirector {
        get {
            guard let value: TableDirector = associated.get(&TableKey) else {
                let temp = TableDirector(tableView)
                associated.set(retain: &TableKey, temp)
                return temp
            }
            return value
        }
        set { associated.set(retain: &TableKey, newValue) }
    }
    
    func didLayoutTable() {
        view.addSubview(tableView)
        tableView.fillToSuperview()
    }
}

extension UIViewController {
    
    static let swizzled: Void = {
        do {
            let originalSelector = #selector(UIViewController.viewDidLoad)
            let swizzledSelector = #selector(UIViewController._viewDidLoad)
            swizzled_method(originalSelector, swizzledSelector)
        }
    } ()
    
    @objc
    private func _viewDidLoad() {
        _viewDidLoad()
        (self as? DSLAutoTable)?.didLayoutTable()
        (self as? DSLTable)?.reloadTable()
    }
}

