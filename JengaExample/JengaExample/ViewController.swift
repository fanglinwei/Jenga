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
        NavigationRow("State Binding")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(StateViewController(), animated: true)
            }
        NavigationRow("HeaderFooter")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(HeaderFooterViewController(), animated: true)
            }
        NavigationRow("WrapperRow")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(ViewRowViewController(), animated: true)
            }
        NavigationRow("OnTap 泛型支持")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(OnTapViewController(), animated: true)
            }
        NavigationRow("测试")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(TableViewController(), animated: true)
            }
        NavigationRow("多开关复用测试")
            .onTap(on: self) { (self) in
                self.navigationController?.pushViewController(SwitchViewController(), animated: true)
            }
    }
}
