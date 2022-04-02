//
//  CustomTableViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/30.
//

import UIKit
import Jenga

class CustomTableViewController: BaseViewController, DSLTable {
    
    override var pageTitle: String { get { "自定义TableView" } }
    
    @State var array: [String] = (0 ... 100).map { "\($0)" }
        
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    lazy var table = TableDirector(tableView, delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setup() {
        view.addSubview(tableView)
    }
}

// DSL
extension CustomTableViewController {
    
    @TableBuilder
    var tableContents: [Section] {
        
        TableSection(binding: $array) {
            TableRow<EmojiCell>()
                .data($0)
                .height(44)
        }
        .headerHeight(UITableView.automaticDimension)
    }
}

extension CustomTableViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}

