//
//  ViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func action(_ sender: Any) {
        navigationController?.pushViewController(TableViewController(), animated: true)
    }
}

class TableViewController: UIViewController, DSLAutoTable {
    
    deinit { print("deinit", classForCoder) }
    
    @State var text = "OC"
    
    @State var detailText = "+86"
    
    @State var isOn = true
    
    var id: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
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
    var tableContents: [Sectionable] {
        
        TableSection {
            
            TableRow<BannerCell>("banner_image")
                .height(120)
            
            TableRow<BannerCell>("banner_image")
                .height(120)
            
            TableRow<BannerCell>("banner_image")
                .height(120)
            
            TableRow<BannerCell>("banner_image")
                .height(120)
            
            TableRow<BannerCell>("banner_image")
                .height(120)
            
            SeparatorRow(10)
            
            TableRow<BannerCell>()
                .height(120)
                .data("banner_image")
                .customize { (cell, value) in
                    print(cell, value)
                }
        }
        .headerHeight(20)
        
        TableSection {
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
        }
        .rowHeight(52)
        .headerHeight(20)
        
        
        // 测试复用
        TableSection {
            NavigationRow("🤣")
            NavigationRow("😄")
            
            if isOn {
                NavigationRow("😃")
            }
        }
        .rowHeight(52)
        .headerHeight(20)
        
        TableSection {
            
            TapActionRow("切换开关")
                .onTap(on: self) { (self) in
                    self.isOn.toggle()
                    self.reloadTable()
                }
        }
    }
}
