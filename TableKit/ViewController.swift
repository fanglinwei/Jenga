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
    
    @State var text = ""
    
    @State var isOn = true
    
    var id: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isOn = false
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
            
            SeparatorRow(10)
            
            TableRow<BannerCell>()
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
        }
        .rowHeight(52)
        .headerHeight(20)
        
        TableSection {
            
            NavigationRow("用户协议")
                .onTap {
                    
                }
            
            ToggleRow("开关", isOn: $isOn)
                .onTap(on: self) { (self, isOn) in
                    print(self.id)
                    print(isOn)
                    print(self.isOn)
                }
        }
        .rowHeight(52)
        .headerHeight(20)
    }
}
