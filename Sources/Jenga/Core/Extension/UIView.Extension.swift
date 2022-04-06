//
//  UIView.Extension.swift
//  Jenga
//
//  Created by 方林威 on 2022/3/30.
//  Copyright © 2022 LEE. All rights reserved.
//

import UIKit

extension UIView {

    func fillToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
}

extension UITableView {

    static var zero: CGFloat = 0.001
    
    func setSectionHeaderTopPadding(_ value: CGFloat) {
        if #available(iOS 15.0, *) { sectionHeaderTopPadding = value }
    }
}

public extension UITableView {

    static var highAutomaticDimension: CGFloat = -999
}

