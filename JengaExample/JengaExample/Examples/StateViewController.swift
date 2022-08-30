//
//  StateViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/4/6.
//

import UIKit
import Jenga

class StateViewController: BaseViewController, DSLAutoTable {
    
    override var pageTitle: String { get { "状态绑定" } }
    
    @State var people: People = .init(name: "Jack", height: 185, weight: 130, gender: true, age: 28)
    @State private var disabled = false
    
    // DSL
    var tableBody: [Table] {
        
        TableSection(binding: $people) { (people: People) in
            NavigationRow("名字").detailText(people.name)
            NavigationRow("身高").detailText("\(people.height)")
            NavigationRow("体重").detailText("\(people.weight)")
            NavigationRow("性别").detailText(people.gender ? "男" : "女")
            if people.gender {
                NavigationRow("爱好").detailText("打游戏")
            }
            NavigationRow("年龄").detailText("\(people.age)")
        }
        .footerHeight(UITableView.automaticDimension)
        
        TapActionRow("点击")
            .onTap(on: self) { (self) in
                self.people.gender.toggle()
            }
        
        
        TableSection {
            TapActionRow("测试点击")
                .onTap(on: self) { (self) in
                    print("测试点击")
                }
                .disabled($disabled)
            
            TapActionRow($disabled.map { $0 ? "开启" : "禁用"})
                .onTap(on: self) { (self) in
                    self.disabled.toggle()
                }
        }
        .header("禁用")
    }
}

extension StateViewController {
    
    struct People {
        let name: String
        let height: Double
        let weight: Double
        var gender: Bool
        var age: Int
    }
}
