//
//  Kingfisher.Extension.swift
//  JengaExample
//
//  Created by 方林威 on 2022/3/30.
//

import Foundation
import Kingfisher

extension String: Resource {
    
    public var cacheKey: String { return self }
    public var downloadURL: URL { return URL(string: self) ?? URL(string: "https://www.baidu.com")! }
}

