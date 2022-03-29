//
//  SettingViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/29.
//

import UIKit

class SettingViewController: UIViewController, DSLAutoTable {
    
    @State var text = "OC"
    
    @State var detailText1 = "OC"
    
    @State var text2 = "OC"
    
    @State var detailText = "+86"
    
    @State var isHiddenCat = true
    
    @State var isRed = true
    
    @State var badgeValue: String? = "1"
    
    @State var isOn2 = true
    
    var id: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.text = "Swift"
            self?.detailText1 = "Swift"
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
extension SettingViewController {
    
    @TableBuilder
    var tableContents: [Sectionable] {
        TableSection {
            NavigationRow("账号与安全")
                .onTap {
                    print("123")
                }
            
            NavigationRow("设置高度")
                .accessoryType(.disclosureIndicator)
                .height(60)
        }
        .headerHeight(UITableView.automaticDimension)
        
        TableSection {
            NavigationRow("青少年模式")
                .accessoryType(.disclosureIndicator)
            
            NavigationRow("关怀模式")
                .accessoryType(.disclosureIndicator)
        }
        .headerHeight(20)
        
        TableSection {
            NavigationRow("Value1")
                .detailText("Value1")
                .accessoryType(.disclosureIndicator)
            
            NavigationRow("Subtitle")
                .detailText(.subtitle("Subtitle"))
                .accessoryType(.disclosureIndicator)
            
            NavigationRow("Value2")
                .detailText(.value2("Value2"))
                .accessoryType(.disclosureIndicator)
            
            NavigationRow("数据绑定")
                .detailText($detailText1.map { .value1($0)} )
                .accessoryType(.disclosureIndicator)
            
            NavigationRow("修改样式")
                .detailText(.subtitle("123123"))
                .text(\.font, .systemFont(ofSize: 20, weight: .semibold))
                .text(\.color, .orange)
                .detail(\.font, .systemFont(ofSize: 11, weight: .light))
                .detail(\.color, .blue)
                .detail(\.edgeInsets, .init(top: 20, left: 30, bottom: 0, right: 0))
                .accessoryType(.disclosureIndicator)
                .customize { cell in
                    cell.backgroundColor = .green
                }
        }
        .header("detailText")
        .headerHeight(UITableView.automaticDimension)
        
        TableSection {
            ToggleRow("隐藏小猫", isOn: $isHiddenCat)
                .onTap(on: self) { (self, isOn) in
                    self.isHiddenCat = isOn
                }
            
            ToggleRow("Switch 2", isOn: $isOn2)
                .onTap(on: self) { (self, isOn) in
                    self.reloadTable()
                }
        }
        .header("Toggle")
        .rowHeight(52)
        .headerHeight(UITableView.automaticDimension)
        
        TableSection(binding: $isHiddenCat) { isOn in
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
        
        if isOn2 {
            TableSection {
                NavigationRow("🤣")
                NavigationRow("😄")
            }
            .rowHeight(52)
            .headerHeight(20)
        }
        
        TableSection {
            TapActionRow("Tap Action")
                .onTap(on: self) { (self) in
                    self.isHiddenCat.toggle()
                }
            
            TapActionRow("Tap Action")
                .textAlignment(.left)
                .onTap(on: self) { (self) in
                    
                }
        }
        .header("Tap")
        .rowHeight(52)
        .headerHeight(UITableView.automaticDimension)
        
        TableSection {
            NavigationBadgeRow("小红点")
                .badgeValue($isRed)
//                .badgeColor(.blue)
                .onTap {
                    
                }
            
            NavigationBadgeRow("数字")
                .badgeValue($badgeValue)
//                .badgeColor(.red)
                .onTap {
                    
                }
            
            TapActionRow("Tap Action")
                .textAlignment(.left)
                .onTap(on: self) { (self) in
                    self.isRed.toggle()
                }
        }
        .header("Badge")
        .rowHeight(52)
        .headerHeight(UITableView.automaticDimension)
    }
}

