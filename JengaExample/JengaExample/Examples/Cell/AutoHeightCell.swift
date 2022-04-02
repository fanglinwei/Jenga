//
//  AutoHeightCell.swift
//  JengaExample
//
//  Created by 方林威 on 2022/4/2.
//

import UIKit
import Jenga

class AutoHeightCell: UITableViewCell {
    
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
        contentView.backgroundColor = .random
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        contentView.addSubview(label)
        label.fillToSuperview(.init(top: 10, left: 10, bottom: -10, right: -10))
    }
}

extension AutoHeightCell: ConfigurableCell {
    typealias Data = String
    
    func configure(with data: Data) {
        label.text = data
    }
}

extension UIColor {

    /// SwifterSwift: Random color.
    static var random: UIColor {
        let red = CGFloat.random(in: 0...255.0) / 255.0
        let green = CGFloat.random(in: 0...255.0) / 255.0
        let blue = CGFloat.random(in: 0...255.0) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UIView {

    func fillToSuperview(_ insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor, constant: insets.right)
            let top = topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
}

