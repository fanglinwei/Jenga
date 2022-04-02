import UIKit

struct TableCellRegisterer {

    private var registeredIds = Set<String>()
    private weak var tableView: UITableView?
    
    init(tableView: UITableView?) {
        self.tableView = tableView
    }
    
    mutating func register(cellType: AnyClass, forCellReuseIdentifier reuseIdentifier: String) {
        guard !registeredIds.contains(reuseIdentifier) else {
            return
        }
        guard tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier) == nil else {
            registeredIds.insert(reuseIdentifier)
            return
        }
        
        let bundle = Bundle(for: cellType)
        if let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") {
            tableView?.register(UINib(nibName: reuseIdentifier, bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
        } else {
            tableView?.register(cellType, forCellReuseIdentifier: reuseIdentifier)
        }
        
        registeredIds.insert(reuseIdentifier)
    }
}
