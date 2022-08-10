//
//  SwitchViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/8/10.
//

import UIKit
import Jenga
import Kingfisher

class SwitchViewController: BaseViewController, DSLAutoTable {
    
    override var pageTitle: String { get { "开关压力测试" } }
    
    @State var detailText = "OC"
    
    @State var isRed = true
    
    @State var badgeValue: Int = 0
    
    @State var isOn = true
    
    @State var isOn1 = true
    
    var id: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.detailText = "Swift"
        }
    }
}

// DSL
extension SwitchViewController {
    
    @TableBuilder
    var tableBody: [Table] {
        
        TableSection {
            
            ToggleRow("Switch111", isOn: $isOn)
                .onTap(on: self) { (self, isOn) in
                    self.reloadTable()
                }
        }
        .header("Toggle")
        
        if isOn {
            TableSection {
                NavigationRow("🤣")
                NavigationRow("😄")
            }
            .headerHeight(UITableView.automaticDimension)
        }
        TableSection {
            
            ToggleRow("Switch", isOn: $isOn)
                .onTap(on: self) { (self, isOn) in
//                    self.reloadTable()
                }
        }
        .header("Toggle")
        
        TableSection {
            
            ToggleRow("Switch", isOn: $isOn1)
                .onTap(on: self) { (self, isOn) in
//                    self.reloadTable()
                }
        }
        .header("Toggle")
        
        TableSection {
            
            ToggleRow("Switch", isOn: $isOn1)
                .onTap(on: self) { (self, isOn) in
//                    self.reloadTable()
                }
        }
        .header("Toggle")
        
        TableSection {
            
            ToggleRow("Switch", isOn: $isOn1)
                .onTap(on: self) { (self, isOn) in
//                    self.reloadTable()
                }
        }
        .header("Toggle")
        
        TableSection {
            
            ToggleRow("Switch", isOn: $isOn1)
                .onTap(on: self) { (self, isOn) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.reloadTable()
                    }
                }
        }
        .header("Toggle")
    }
}


