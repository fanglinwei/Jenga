//
//  ViewController.swift
//  InsetGrouped
//
//  Created by 方林威 on 2022/3/30.
//

import UIKit
import Jenga

class ViewController: UIViewController, DSLAutoTable {

    var tableBody: [Table] {
        
        TableHeader("我是头部")
        NavigationRow("设置样式")
        NavigationRow("自定义Cell")
        NavigationRow("自定义TableView")
        TableFooter("我是底部")
        
        TableHeader("第二组")
            .height(100)
        NavigationRow("cell")
    }
}
