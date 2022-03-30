//
//  TableKit.Log.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import Foundation

func log(_ items: Any..., separator: String = " ") {
    guard JengaProvider.isEnabledLog else { return }
    
    let content = String(items.map { "\($0)" }.joined(separator: " "))
    Swift.print("[TableKit]", content , separator:separator, terminator: "\n")
}


