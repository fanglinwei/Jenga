//
//  HeaderFooterViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/4/6.
//

import UIKit
import Jenga

class HeaderFooterViewController: BaseViewController, DSLAutoTable {
    
    override var pageTitle: String { get { "HeaderFooter" } }
    
    var tableBody: [Table] {
        
        TableHeader(.clean)
        NavigationRow("青少年模式")
        NavigationRow("关怀模式")
        TableFooter(.clean)
        
        TableHeader(.string("123"))
        NavigationRow("青少年模式")
        NavigationRow("关怀模式")
        
        TableSection {
            NavigationRow("编辑").icon(.image(named: "编辑"))
            NavigationRow("打卡").icon(.image(named: "打卡"))
            NavigationRow("会员").icon(.image(named: "会员"))
            NavigationRow("卡包").icon(.image(named: "卡包"))
            NavigationRow("赞评").icon(.image(named: "赞评"))
                .onTap { }
        }
        .header("icon")
        
        TableSection {
            NavigationRow("网易云音乐")
                .icon(.async("https://img0.baidu.com/it/u=3699065431,2081224573&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500")
                    .by(const: 25)
                    .by(cornerRadius: 4)
                )
            
            NavigationRow("微博")
                .icon(.async("https://img0.baidu.com/it/u=4030060868,687492768&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500")
                    .by(const: 25)
                    .by(cornerRadius: 4)
                )
            
            NavigationRow("抖音")
                .icon(.async("https://img2.baidu.com/it/u=1454078813,1292711263&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500")
                    .by(const: 25)
                    .by(cornerRadius: 4)
                )
                .onTap {
                    
                }
        }
        .header("async icon")
    }
}
