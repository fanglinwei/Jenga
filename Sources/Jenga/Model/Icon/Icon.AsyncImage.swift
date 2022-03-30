//
//  Icon.AsyncImage.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import Foundation
import UIKit

public protocol AsyncImage {
    func loadImage(with imageView: UIImageView?, _ completion: @escaping (Bool) -> Void)
}
