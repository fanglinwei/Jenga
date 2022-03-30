//
//  CustomViewController.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/29.
//

import UIKit
import Jenga

class CustomViewController: UIViewController, DSLAutoTable {
    
    @State var emojis: [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
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
            
            TableRow<BannerCell>("image1")
                .height(1184 / 2256 * (UIScreen.main.bounds.width - 32))
                .customize { [weak self] cell in
                    cell.delegate = self
                }
            
            SeparatorRow(10)
            
            TableRow<BannerCell>()
                .height(1540 / 2078 * (UIScreen.main.bounds.width - 32))
                .data("image2")
                .customize { (cell, value) in
                    print(cell, value)
                }
        }
        .headerHeight(20)
        
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

extension CustomViewController {
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.emojis = ["🐶", "🐱", "🐭", "🦁", "🐼"]
        }
    }
}

extension CustomViewController: BannerCellDelegate {
    
    func bannerOpenAction() {
        UIApplication.shared.open(URL(string: "https://github.com/fanglinwei/TableKit")!)
    }
}

let randomEmojis = ["🥕", "🍋", "🍉", "🍇", "🥑"]
