//
//  EmojiViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/3/31.
//

import UIKit
import Jenga

class EmojiViewController: UIViewController, DSLAutoTable {
    
    @State var emojis: [String] = ["🐶", "🐱", "🐭", "🦁", "🐼"]
    
    // DSL
    @TableBuilder
    var tableContents: [Section] {
        
        TableSection {
            NavigationRow("123")
        }
        
        TableSection(binding: $emojis) {
            TableRow<EmojiCell>()
                .data($0)
                .height(44)
        }
        .headerHeight(UITableView.automaticDimension)
        
        TableSection {
            TapActionRow("Random")
                .onTap(on: self) { (self) in
                    guard self.emojis.count > 3 else { return }
                    self.emojis[2] = randomEmojis[Int.random(in: 0 ... 4)]
                    self.emojis[3] = randomEmojis[Int.random(in: 0 ... 4)]
                }
            
            TapActionRow("+")
                .onTap(on: self) { (self) in
                    self.emojis.append(randomEmojis[Int.random(in: 0 ... 4)])
                }
            
            TapActionRow("-")
                .onTap(on: self) { (self) in
                    guard self.emojis.count > 0 else { return }
                    _ = self.emojis.popLast()
                }
        }
        .headerHeight(UITableView.automaticDimension)
    }
}

let randomEmojis = ["🥕", "🍋", "🍉", "🍇", "🥑"]
