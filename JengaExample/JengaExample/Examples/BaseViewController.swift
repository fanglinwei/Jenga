//
//  BaseViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/4/2.
//

import UIKit

class BaseViewController: UIViewController {
    
    var pageTitle: String { "" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = pageTitle
    }
    
    deinit { print("deinit", classForCoder) }
}
