//
//  EmojiCell.swift
//  JengaExample
//
//  Created by 方林威 on 2022/4/2.
//

import UIKit
import Jenga

class EmojiCell: UITableViewCell {
    
    private lazy var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(label)
        label.fillToSuperview()
        label.textAlignment = .center
    }
}

extension EmojiCell: ConfigurableCell {
    typealias Data = String
    
    func configure(with data: Data) {
        label.text = data
    }
}
