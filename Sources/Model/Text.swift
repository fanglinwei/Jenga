//
//  Text.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import UIKit

public struct Text: Equatable {
    
    public var string: String?
    public var attributedString: NSAttributedString?
    public var font: UIFont?
    public var color: UIColor?
    public var edgeInsets: UIEdgeInsets = .zero
    
    func with<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var temp = self
        temp[keyPath: keyPath] = value
        return temp
    }
}
