//
//  NavigationBadgeRow.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/11.
//

import UIKit
import Jenga

class NavigationBadgeRow<Cell: NavigationBadgeCell>: NavigationRow<Cell>, BadgeRowCompatible {
    
    var badgeValue: Binding<String?> = .constant(nil)
    var badgeColor: Binding<UIColor>?
    
    override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? Cell)?.configure(with: self)
    }
}

extension NavigationBadgeRow {
    
    func badgeValue(_ value: Binding<Bool>) -> Self {
        self.badgeValue = value.map { $0 ? "" : nil }
        return self
    }
    
    func badgeValue(_ value: Binding<String?>) -> Self {
        self.badgeValue = value
        return self
    }
    
    func badgeColor(_ value: UIColor) -> Self {
        self.badgeColor = .constant(value)
        return self
    }
    
    func badgeColor(_ value: Binding<UIColor>) -> Self {
        self.badgeColor = value
        return self
    }
}
