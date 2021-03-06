//
//  SettingViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/29.
//

import UIKit
import Jenga
import Kingfisher

class SettingViewController: BaseViewController, DSLAutoTable {
    
    override var pageTitle: String { get { "设置" } }
    
    @State var detailText = "OC"
    
    @State var isRed = true
    
    @State var badgeValue: Int = 0
    
    @State var isOn = true
    
    var id: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.detailText = "Swift"
        }
    }
}

// DSL
extension SettingViewController {
    
    @TableBuilder
    var tableBody: [Table] {

        TableSection {
            NavigationRow("青少年模式")
            NavigationRow("关怀模式")
                .height(52)
        }
        
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
        
        TableSection {
            NavigationRow("Value1")
                .detailText("Value1")
            
            NavigationRow("Subtitle")
                .detailText(.subtitle("Subtitle"))
            
            NavigationRow("Value2")
                .detailText(.value2("Value2"))
            
            NavigationRow("数据绑定")
                .detailText($detailText.map { .value1($0)} )
            
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
        
        TableSection {
            
            ToggleRow("Switch", isOn: $isOn)
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
            NavigationBadgeRow("小红点")
                .badgeValue($isRed)
                .badgeColor(.blue)
                .accessoryType(.disclosureIndicator)
            
            NavigationBadgeRow("小红点")
                .detailText("子标题")
                .badgeValue($isRed)
                .badgeColor(.blue)
                .accessoryType(.disclosureIndicator)

            TapActionRow("切换红点")
                .textAlignment(.center)
                .onTap(on: self) { (self) in
                    self.isRed.toggle()
                }
            
            NavigationBadgeRow("数字")
                .badgeValue($badgeValue.map { "\(max($0, 0))" } )
                .badgeColor(.red)
                .accessoryType(.disclosureIndicator)
            
            NavigationBadgeRow("数字")
                .detailText("子标题")
                .badgeValue($badgeValue.map { "\(max($0, 0))" } )
                .badgeColor(.red)
                .accessoryType(.disclosureIndicator)
            
            TapActionRow("+")
                .textAlignment(.center)
                .onTap(on: self) { (self) in
                    self.badgeValue += 1
                }
            
            TapActionRow("-")
                .textAlignment(.center)
                .onTap(on: self) { (self) in
                    self.badgeValue -= 1
                }
        }
        .headerHeight(UITableView.automaticDimension)
        .header("Badge")
    }
}

