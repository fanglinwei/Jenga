//
//  TableKit.swift
//  Zunionv 
//
//  Created by 方林威 on 2022/2/25.
//

import UIKit

enum DSLTableManager { }

public protocol RowHeightCalculator {
    
    func height(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    func estimatedHeight(forRow row: Row, at indexPath: IndexPath) -> CGFloat
    
    func invalidate()
}

public enum TableRowActionType {
    
    case click
    case clickDelete
    case select
    case deselect
    case willSelect
    case willDeselect
    case willDisplay
    case didEndDisplaying
    case shouldHighlight
    case shouldBeginMultipleSelection
    case didBeginMultipleSelection
    case height
    case canEdit
    case configure
    case canDelete
    case canMove
    case canMoveTo
    case move
    case showContextMenu
    case accessoryButtonTap
    case custom(String)
    
    var key: String {
        
        switch (self) {
        case .custom(let key):
            return key
        default:
            return "_\(self)"
        }
    }
}

//func `deinit`(item: Any...) {
//    let result = "deinit" + item.map { "\($0)" }.joined(separator: "\t")
//    print(result, separator: "\t")
//}
