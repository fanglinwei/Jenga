//
//  Spacer.swift
//  Jenga
//
//  Created by 方林威 on 2022/4/1.
//

import UIKit

public protocol Spacer {
    
    var height: RowHeight { get }
    
    var color: UIColor { get set }
}


public struct TableSpacer: Spacer {
    
    public let height: RowHeight
    
    public var color: UIColor = .clear
    
    public init(_ height: RowHeight = 10, color: UIColor = .clear) {
        self.height = height
        self.color = color
    }
}

extension TableSpacer: Reform { }

public extension TableSpacer {
    
    func color(_ value: UIColor) -> Self {
        reform { $0.color = value }
    }
}
