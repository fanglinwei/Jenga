//
//  TableKit.Log.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import Foundation

internal func log(_ items: Any..., separator: String = " ") {
    guard JengaEnvironment.isEnabledLog else { return }
    
    let content = String(items.map { "\($0)" }.joined(separator: " "))
    Swift.print("[Jenga]", content , separator:separator, terminator: "\n")
}
