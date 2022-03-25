//
//  Text.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import UIKit

public struct Text: Equatable {
    
    var string: String?
    var attributedString: NSAttributedString?
    var font: UIFont?
    var color: UIColor?
    var edgeInsets: UIEdgeInsets = .zero
    
    func with<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var temp = self
        temp[keyPath: keyPath] = value
        return temp
    }
}
