//
//  SettingViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/29.
//

import UIKit
import Jenga
import Kingfisher

class SettingViewController: UIViewController, DSLAutoTable {
    
    @State var text = "OC"
    
    @State var detailText1 = "OC"
    
    @State var text2 = "OC"
    
    @State var detailText = "+86"
    
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
    var tableBody: [Table] {

        TableSection {
            NavigationRow("青少年模式")
            NavigationRow("关怀模式")
        }
        .headerHeight(20)
        
        TableSection {
            NavigationRow("编辑").icon(.image(named: "编辑"))
            NavigationRow("打卡").icon(.image(named: "打卡"))
            NavigationRow("会员").icon(.image(named: "会员"))
            NavigationRow("卡包").icon(.image(named: "卡包"))
            NavigationRow("赞评").icon(.image(named: "赞评"))
                .onTap { }
        }
        .header("icon")
        .headerHeight(UITableView.automaticDimension)
        
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
        .headerHeight(UITableView.automaticDimension)
        
        TableSection {
            NavigationRow("Value1")
                .detailText("Value1")
            
            NavigationRow("Subtitle")
                .detailText(.subtitle("Subtitle"))
            
            NavigationRow("Value2")
                .detailText(.value2("Value2"))
            
            NavigationRow("数据绑定")
                .detailText($detailText1.map { .value1($0)} )
            
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
            
            ToggleRow("Switch 2", isOn: $isOn2)
                .onTap(on: self) { (self, isOn) in
                    self.reloadTable()
                }
        }
        .header("Toggle")
        .rowHeight(52)
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
                .textAlignment(.left)
                .onTap(on: self) { (self) in
                    
                }
        }
        .header("Tap")
        .rowHeight(52)
        .headerHeight(UITableView.automaticDimension)
        
        TableSection {
//            NavigationBadgeRow("小红点")
//                .badgeValue($isRed)
//                .badgeColor(.blue)
//                .onTap {
//
//                }
//
//            NavigationBadgeRow("数字")
//                .badgeValue($badgeValue)
//                .badgeColor(.red)
//                .onTap {
//
//                }

            TapActionRow("Tap Action")
                .textAlignment(.left)
                .onTap(on: self) { (self) in
                    self.isRed.toggle()
                }
        }
//        .header("Badge")
        .rowHeight(52)
        .headerHeight(UITableView.automaticDimension)
    }
}

