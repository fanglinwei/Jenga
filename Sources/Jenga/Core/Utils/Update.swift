//
//  Edit.swift
//  Jenga
//
//  Created by 方林威 on 2022/4/2.
//

import Foundation

public protocol Update {}

extension Update where Self: Any {
    
    @inlinable
    public func update(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

extension Update where Self: AnyObject {
    
    @inlinable
    public func update(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}
