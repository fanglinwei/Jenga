//
//  NavigationRow2.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/25.
//

import UIKit
import Jenga

public class NavigationRow2<Cell: NavigationCell>: NavigationRow<Cell> {
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? Cell)?.configure(with: self)
    }
}

public class NavigationCell: UITableViewCell, ConfigurableCell {
    
    private var row: Row?
    open func configure(with row: Row) {
        self.row = row
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let row = row as? NavigationRowCompatible else {
            return
        }
        switch row.cellStyle {
        case .value1 where row.accessoryType == .disclosureIndicator:
            let frame = detailTextLabel?.frame ?? .zero
            
            let x: CGFloat = contentView.bounds.width - frame.width - 4

            detailTextLabel?.frame = CGRect(
                x: x,
                y: frame.minY,
                width: frame.width,
                height: frame.height
            )
            
        default:
            break
        }
    }
}
