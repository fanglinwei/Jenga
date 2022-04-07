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

extension AsyncImage: Reform { }

public extension AsyncImage {
    
    static func async(_ source: Resource, placeholder: Placeholder? = .none, options: KingfisherOptionsInfo = []) -> Self {
        return .init(source, placeholder: placeholder, options: options)
    }
    
    func placeholder(_ value: Placeholder?) -> Self {
        reform { $0.placeholder = value }
    }
    
    func by(size: CGSize) -> Self {
        reform {
            $0.processor = RoundCornerImageProcessor(
                radius: processor.radius,
                targetSize: size,
                roundingCorners: processor.roundingCorners,
                backgroundColor: processor.backgroundColor
            )
        }
    }
    
    func by(const: CGFloat) -> Self {
        by(size: CGSize(width: const, height: const))
    }
    
    func by(roundingCorners value: RectCorner) -> Self {
        reform {
            $0.processor = RoundCornerImageProcessor(
                radius: processor.radius,
                targetSize: processor.targetSize,
                roundingCorners: value,
                backgroundColor: processor.backgroundColor
            )
        }
    }
    
    func by(cornerRadius value: CGFloat? = nil) -> Self {
        let radius: RoundCornerImageProcessor.Radius = value != nil ? .point(value!) : .widthFraction(0.5)
        
        return reform {
            $0.processor = RoundCornerImageProcessor(
                radius: radius,
                targetSize: processor.targetSize,
                roundingCorners: processor.roundingCorners,
                backgroundColor: processor.backgroundColor
            )
        }
    }
}

public extension SystemRow {
    
    func icon(_ value: Binding<AsyncImage>) -> Self {
        reform { $0.icon = value.map { .async($0) }}
    }
    
    func icon(_ value: AsyncImage) -> Self {
        reform { $0.icon = .constant(.async(value)) }
    }
}


