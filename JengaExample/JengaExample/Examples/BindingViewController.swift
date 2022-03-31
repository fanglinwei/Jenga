//
//  BindingViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/3/31.
//

import UIKit
import Jenga

class BindingViewController: UIViewController, DSLAutoTable {
    
    @State var text = "objective-c"
    
    @State var detailText = "TableView"
    
    @State var isShowCat = false
    
    // DSL
    @TableBuilder
    var tableContents: [Section] {
        
        TableSection {
            NavigationRow($text)
                .detailText($detailText)
            
            ToggleRow("显示小猫", isOn: $isShowCat)
                .onTap(on: self) { (self, isOn) in
                    self.isShowCat = isOn
                }
            
        }
        .header("Toggle")
        .rowHeight(52)
        .headerHeight(UITableView.automaticDimension)
        
        TableSection(binding: $isShowCat) { isOn in
            NavigationRow("🐶")
            NavigationRow("🐶")
            NavigationRow("🐶")
  
            if isOn {
                NavigationRow("🐱")
                NavigationRow("🐱")
                NavigationRow("🐱")
            }
        }
        .header("Animal")
        .headerHeight(UITableView.automaticDimension)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        text = "Swift"
//        detailText = "Jenga"
//        isShowCat = true
    }
}

