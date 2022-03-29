//
//  ViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/11.
//

import UIKit

class ViewController: UIViewController, DSLAutoTable {

    @TableBuilder
    var tableContents: [Sectionable] {
        TableSection {
            NavigationRow("设置样式")
                .onTap(on: self) { (self) in
                    self.navigationController?.pushViewController(SettingViewController(), animated: true)
                }
            
            NavigationRow("自定义样式")
                .onTap(on: self) { (self) in
                    self.navigationController?.pushViewController(CustomViewController(), animated: true)
                }
            
            NavigationRow("测试")
                .onTap(on: self) { (self) in
                    self.navigationController?.pushViewController(TableViewController(), animated: true)
                }
        }
    }
}

