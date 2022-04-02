//
//  Collection.Extension.swift
//  Jenga
//
//  Created by 方林威 on 2022/3/30.
//  Copyright © 2022 LEE. All rights reserved.
//

import Foundation
import UIKit

internal extension Collection {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

internal extension Optional where Wrapped: Collection {

    /// SwifterSwift: Check if optional is nil or empty collection.
    var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }

    /// SwifterSwift: Returns the collection only if it is not nill and not empty.
    var nonEmpty: Wrapped? {
        guard let collection = self else { return nil }
        guard !collection.isEmpty else { return nil }
        return collection
    }
}

extension Optional where Wrapped == CGFloat {
    
    var nonEfficient: Wrapped? {
        guard let float = self else { return nil }
        guard float != UITableView.highAutomaticDimension else { return nil }
        guard float != 0 else { return nil }
        return float
    }
}
