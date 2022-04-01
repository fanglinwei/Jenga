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
    var tableBody: [Table] {
        
        TableHeader("伟大的LEE")
        
        NavigationRow("设置样式")
        NavigationRow("自定义Cell")
        NavigationRow("自定义TableView")
        
        TableFooter("小逼崽子")
        
        TableHeader("LEE")
            .height(100)
        
        NavigationRow("测试")
    }
}
