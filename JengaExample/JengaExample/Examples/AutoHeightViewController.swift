//
//  AutoHeightViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/4/2.
//

import UIKit
import Jenga

class AutoHeightViewController: BaseViewController, DSLAutoTable {
    
    override var pageTitle: String { get { "自动计算缓存行高" } }
    
    @State private var datas = contents
    
    // DSL
    var tableBody: [Table] {
        TableSection.init(binding: $datas) {
            TableRow<AutoHeightCell>($0)
                .height(UITableView.highAutomaticDimension)
        }
        .rowHeight(UITableView.highAutomaticDimension)
        
        // 系统样式暴力测试
        TableSection {
            NavigationRow("Value1")
                .detailText("Value1")
            
            NavigationRow("SubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitle")
                .detailText(.subtitle("SubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitle"))
                .detail(\.numberOfLines, 0)
                .text(\.numberOfLines, 0)
            
            NavigationRow("Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2")
                .detailText(.value2("Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2Value2"))
                .detail(\.numberOfLines, 0)
                .text(\.numberOfLines, 0)
            
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
            
            ToggleRow("Switch", isOn: .constant(false))
                .detailText(.subtitle("SubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitleSubtitle"))
                .detail(\.numberOfLines, 0)
        }
        .rowHeight(UITableView.highAutomaticDimension)
        .header("detailText")
    }
}

private let contents: [String] = [
    
"""
始是相逢疑梦中，情深情浅错缘生

菩提花开满宫墙，花下是谁对影成双

步生莲，桃花债，三生三世枕上书。

等佛铃盛放，将眉眼深藏，再开出回忆里你知的模样。
""",
"""
满地黄花堆积。憔悴损，如今有谁堪摘？
""",
"""
这次第，怎一个愁字了得！
""",
"""
生当作人杰，死亦为鬼雄，至今思项羽，不肯过江东。
""",
"枕上诗书闲处好，门前风景雨来佳。终日向人多藉藉，木犀花\n枕上诗书闲处好，门前风景雨来佳。终日向人多藉藉，木犀花",
"""
伤心枕上三更雨，点滴霖霪。愁损北人，不惯起来听。
""",

"""
始是相逢疑梦中，情深情浅错缘生

菩提花开满宫墙，花下是谁对影成双

步生莲，桃花债，三生三世枕上书。

等佛铃盛放，将眉眼深藏，再开出回忆里你知的模样。
""",
"""
满地黄花堆积。憔悴损，如今有谁堪摘？
""",
"""
这次第，怎一个愁字了得！
""",
"""
生当作人杰，死亦为鬼雄，至今思项羽，不肯过江东。
""",
"""
枕上诗书闲处好，门前风景雨来佳。终日向人多藉藉，木犀花
""",
"""
伤心枕上三更雨，点滴霖霪。愁损北人，不惯起来听。
""",

"""
始是相逢疑梦中，情深情浅错缘生

菩提花开满宫墙，花下是谁对影成双

步生莲，桃花债，三生三世枕上书。

等佛铃盛放，将眉眼深藏，再开出回忆里你知的模样。
""",
"""
满地黄花堆积。憔悴损，如今有谁堪摘？
""",
"""
这次第，怎一个愁字了得！
""",
"""
生当作人杰，死亦为鬼雄，至今思项羽，不肯过江东。
""",
"""
枕上诗书闲处好，门前风景雨来佳。终日向人多藉藉，木犀花
""",
"""
伤心枕上三更雨，点滴霖霪。愁损北人，不惯起来听。
""",

"""
始是相逢疑梦中，情深情浅错缘生

菩提花开满宫墙，花下是谁对影成双

步生莲，桃花债，三生三世枕上书。

等佛铃盛放，将眉眼深藏，再开出回忆里你知的模样。
""",
"""
满地黄花堆积。憔悴损，如今有谁堪摘？
""",
"""
这次第，怎一个愁字了得！
""",
"""
生当作人杰，死亦为鬼雄，至今思项羽，不肯过江东。
""",
"""
枕上诗书闲处好，门前风景雨来佳。终日向人多藉藉，木犀花
枕上诗书闲处好，门前风景雨来佳。终日向人多藉藉，木犀花
""",
"""
伤心枕上三更雨，点滴霖霪。愁损北人，不惯起来听。
""",
"""
《浣溪沙·一叶扁舟卷画帘》
【宋】黄庭坚

一叶扁舟卷画帘，老妻学饮伴清谈，

人传诗句满江南。

林下猿垂窥涤砚，岩前鹿卧看收帆，

杜鹃声乱水如环。
""",
"""
巍巍符禹山，幽幽梵音谷。翩翩比翼鸟，长居于此处。

此处有佳丽，绝色世应稀。一朝初长成，嫁作上君妻。

赐号名倾画，荣宠无绝期。梵音重贞洁，倾画自谨记。

琴瑟当和谐，与君长相知，相知复相伴，恩爱两不移。

与君恩爱两不移，

唯念生当同寝死同葬！孰知世事无恒常？旋即夫君身先死，惊鸿失偶痛断肠！

风云变幻太嚣张，不管泪尽与心伤。欲赴忘川随君去，腹中遗脉岂能殇？

千回百转不由人，堪忍仇敌变丈夫。幸喜平安得爱女，深埋大恨护遗孤！

堪堪又是数年春， 次女三女相诞辰。忍把亲生遗蛇阵，胸中尤有恨难沉。

辗转筹谋思弄权，毒酒送敌入黄泉。为使遗孤承君位，不惜白骨垒成山！

森森白骨垒成山！次女消亡三女癫，万千将士魂飞散，新君惊恐亦难安。

虎毒犹然不食子，王宫骨肉竞相残！爱卿才貌怜身世，恨卿执念泯良知。

天道循环谁可违？自招因果有轮回。锒铛囹圄卿曾悔？枉作笑谈莫须追！
"""
]
