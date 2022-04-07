//
//  Edit.swift
//  Jenga
//
//  Created by 方林威 on 2022/4/2.
//

import Foundation

public protocol Reform {}

extension Reform where Self: Any {
    
    @inlinable
    public func reform(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

extension Reform where Self: AnyObject {
    
    @inlinable
    public func reform(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}
