//
//  Icon.AsyncImage.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import Jenga
import UIKit
import Kingfisher

public struct AsyncImage: Jenga.AsyncImage {
    
    public var downloadURL: URL { source.downloadURL }
    
    
    /// The initializer is kept private until v2.0 when `methodSignature` is removed.
    public init(_ source: Resource, placeholder: Placeholder? = .none, options: KingfisherOptionsInfo = []) {
        self.source = source
        self.placeholder = placeholder
        self.options = options
    }
    
    var options: KingfisherOptionsInfo = []
    
    /// The image for the normal state.
    let source: Resource
    
    /// The image for the highlighted state.
    var placeholder: Placeholder?
    
    var processor = RoundCornerImageProcessor(cornerRadius: 0) {
        didSet {
            options.append(.processor(processor))
        }
    }
    
    public func loadImage(with imageView: UIImageView?, _ completion: @escaping (Bool) -> Void) {
        imageView?.kf.setImage(
            with: source,
            placeholder: placeholder,
            options: options
        ) {  result in
            switch result {
            case .success:              return completion(true)
            case .failure:              return completion(false)
            }
        }
    }
}

public extension AsyncImage {
    
    static func async(_ source: Resource, placeholder: Placeholder? = .none, options: KingfisherOptionsInfo = []) -> Self {
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

public extension AsyncImage {
    
    func by(cornerRadius value: CGFloat? = nil) -> Self {
        var temp = self
        let radius: RoundCornerImageProcessor.Radius = value != nil ? .point(value!) : .widthFraction(0.5)
        temp.processor = RoundCornerImageProcessor(
            radius: radius,
            targetSize: processor.targetSize,
            roundingCorners: processor.roundingCorners,
            backgroundColor: processor.backgroundColor
        )
        return temp
    }
}

public extension RowSystem {
    
    func icon(_ value: Binding<AsyncImage>) -> Self {
        icon = value.map { .async($0) }
        return self
    }
    
    func icon(_ value: AsyncImage) -> Self {
        icon = .constant(.async(value))
        return self
    }
}


