//
//  ViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/3/30.
//

import UIKit
import Jenga

class ViewController: UIViewController, DSLAutoTable {
    
    var tableBody: [Table] {
        
        NavigationRow("设置样式")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(SettingViewController(), animated: true)
            }
        
        NavigationRow("自定义Cell")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(CustomViewController(), animated: true)
            }
        
        NavigationRow("自动计算缓存行高")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(AutoHeightViewController(), animated: true)
            }
        
        NavigationRow("自定义TableView")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(CustomTableViewController(), animated: true)
            }
        
        NavigationRow("Binding")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(BindingViewController(), animated: true)
            }
        NavigationRow("Section Binding")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(EmojiViewController(), animated: true)
            }
        
        NavigationRow("测试")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(TableViewController(), animated: true)
            }
    }
}

