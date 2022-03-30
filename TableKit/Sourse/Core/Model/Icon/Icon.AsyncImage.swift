//
//  Icon.AsyncImage.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import Foundation
import Kingfisher

extension Icon {
    
    public struct AsyncImage: Equatable {
        
        public static func == (lhs: Icon.AsyncImage, rhs: Icon.AsyncImage) -> Bool {
            lhs.source.cacheKey == rhs.source.cacheKey
        }
        
        /// The initializer is kept private until v2.0 when `methodSignature` is removed.
        public init(_ source: Resource, placeholder: Placeholder? = .none, options: KingfisherOptionsInfo = []) {
            self.source = source
            self.placeholder = placeholder
            self.options = options
        }

        public var options: KingfisherOptionsInfo = []
        
        /// The image for the normal state.
        public let source: Resource
        
        /// The image for the highlighted state.
        public var placeholder: Placeholder?
        
        public var processor = RoundCornerImageProcessor(cornerRadius: 0) {
            didSet {
                options.append(.processor(processor))
            }
        }
    }
}

public extension Icon.AsyncImage {
    
    static func async(_ source: Resource, placeholder: Placeholder? = .none, options: KingfisherOptionsInfo = []) -> Icon.AsyncImage {
        return .init(source, placeholder: placeholder, options: options)
    }
    
    func placeholder(_ value: Placeholder?) -> Self {
        var temp = self
        temp.placeholder = value
        return temp
    }
    
    func by(size: CGSize) -> Self {
        var temp = self
        temp.processor = RoundCornerImageProcessor(
            radius: processor.radius,
            targetSize: size,
            roundingCorners: processor.roundingCorners,
            backgroundColor: processor.backgroundColor
        )
        return temp
    }
    
    func by(const: CGFloat) -> Self {
        by(size: CGSize.init(width: const, height: const))
    }
    
    func by(roundingCorners value: RectCorner) -> Self {
        var temp = self
        temp.processor = RoundCornerImageProcessor(
            radius: processor.radius,
            targetSize: processor.targetSize,
            roundingCorners: value,
            backgroundColor: processor.backgroundColor
        )
        return temp
    }
}
