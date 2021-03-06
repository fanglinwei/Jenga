import UIKit

// 快速列表使用此协议, 协议都有默认实现 controller 只需要实现tableContents即可
public protocol DSLAutoTable: DSLTable {
    
    var tableView: UITableView { get }
    
    func didLayoutTable()
}

private var TableViewKey: Void?
private var TableKey: Void?
public extension DSLAutoTable where Self: UIViewController {

    var tableView: UITableView {
        get {
            guard let value: UITableView = get(&TableViewKey) else {
                let temp = JengaEnvironment.provider.defaultTableView(with: .zero)
                set(retain: &TableViewKey, temp)
                return temp
            }
            return value
        }
        set { set(retain: &TableViewKey, newValue) }
    }
    
    var table: TableDirector {
        get {
            guard let value: TableDirector = get(&TableKey) else {
                let temp = TableDirector(tableView)
                set(retain: &TableKey, temp)
                return temp
            }
            return value
        }
        set { set(retain: &TableKey, newValue) }
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
            let swizzledSelector = #selector(UIViewController.jenga_viewDidLoad)
            swizzled_method(originalSelector, swizzledSelector)
        }
    } ()
    
    @objc
    private func jenga_viewDidLoad() {
        jenga_viewDidLoad()
        (self as? DSLAutoTable)?.didLayoutTable()
        (self as? DSLTable)?.reloadTable()
    }
}

