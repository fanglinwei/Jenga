//
//  CustomViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/29.
//

import Foundation

class CustomViewController: UIViewController, DSLAutoTable {
    
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
    
    deinit { print("deinit", classForCoder) }
}

// DSL
extension CustomViewController {
    
    @TableBuilder
    var tableContents: [Sectionable] {
        
        TableSection {
            
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
    }
}
