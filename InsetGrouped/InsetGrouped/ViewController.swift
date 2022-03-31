//
//  ViewController.swift
//  InsetGrouped
//
//  Created by 方林威 on 2022/3/30.
//

import UIKit
import Jenga

class ViewController: UIViewController, DSLAutoTable {

    @TableBuilder
    var tableContents: [Section] {
        TableSection {
            
            NavigationRow("设置样式")
            NavigationRow("自定义Cell")
            NavigationRow("自定义TableView")
            NavigationRow("测试")
        }
    }
}
