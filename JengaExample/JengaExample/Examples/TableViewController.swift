//
//  TableViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/29.
//

import UIKit
import Jenga

class TableViewController: UIViewController, DSLAutoTable {
    
    deinit { print("deinit", classForCoder) }
    
    @State var text = "OC"
    
    @State var detailText = "+86"
    
    @State var isOn = true
    
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            self?.text = "Swift"
            self?.detailText = "17878787878"
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "设置"
    }
}

// DSL
extension TableViewController {
    
    @TableBuilder
    var tableBody: [Table] {
        
        // 测试复用
        TableHeader()
            .rowHeight(52)
            .height(20)
        
        NavigationRow("用户协议")
            .onTap {
                
            }
        
        ToggleRow("开关1", isOn: $isOn)
            .onTap(on: self) { (self, isOn) in
                print(isOn)
                print(self.isOn)
            }
        
        ToggleRow("开关2", isOn: $isOn)
            .onTap(on: self) { (self, isOn) in
                print(isOn)
                print(self.isOn)
            }
        
        // binding
        NavigationRow($text)
        
        NavigationRow("手机号")
            .detailText($detailText)
        
        TableFooter()
        
        TableSpacer(30)
        
        // 测试复用
        TableHeader("测试")
            .rowHeight(52)
        
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        
        TableSpacer(30)
        
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        // binding
        NavigationRow($text)
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        NavigationRow("🤣")
        NavigationRow("😄")
        
        if isOn {
            NavigationRow("🐶")
        }
        
        TableSection(binding: $isOn) { isOn in
            if isOn {
                NavigationRow("🐶")
            }
        }
        .headerHeight(20)
        
        TableSection {
            
            TapActionRow("切换开关, reloadTable")
                .onTap(on: self) { (self) in
                    self.isOn.toggle()
                    self.reloadTable()
                }
            
            SpacerRow(30)
            
            TapActionRow("切换开关, reload isOn binding")
                .onTap(on: self) { (self) in
                    self.isOn.toggle()
                }
        }
        .headerHeight(20)
    }
}
