//
//  Icon.Image.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/23.
//

import UIKit

public protocol Image {
    
    var image: UIImage? { get }
    
    var highlightedImage: UIImage? { get }
    
    func loadImage(with imageView: UIImageView?, _ completion: @escaping (Bool) -> Void)
}

public struct IconImage: Image {
    
    private let signature: String
    
    public var image: UIImage?
    
    public let highlightedImage: UIImage?
    
    public func loadImage(with imageView: UIImageView?, _ completion: @escaping (Bool) -> Void) {
        imageView?.image = image
        imageView?.highlightedImage = highlightedImage
        completion(true)
    }

    private init(signature: String, image: UIImage?, highlightedImage: UIImage?) {
        self.signature = signature
        self.image = image
        self.highlightedImage = highlightedImage
    }
    
    public static func named(_ name: String, in bundle: Bundle? = .none, compatibleWith traitCollection: UITraitCollection? = .none) -> Self {
        return IconImage(
            signature: "\(#function):\(name)",
            image: UIImage(named: name, in: bundle, compatibleWith: traitCollection),
            highlightedImage: UIImage(named: name + "-highlighted", in: bundle, compatibleWith: traitCollection)
        )
    }

    public static func images(normal: UIImage?, highlighted: UIImage?) -> Self {
        return IconImage(signature: #function, image: normal, highlightedImage: highlighted)
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public static func sfSymbol(_ name: String, withConfiguration configuration: UIImage.Configuration? = .none) -> Self {
        let fallback = UIImage.SymbolConfiguration(textStyle: .body)
        return IconImage(
            signature: "\(#function):\(name)",
            image: UIImage(systemName: name, withConfiguration: configuration ?? fallback),
            highlightedImage: nil
        )
    }
}

public extension IconImage {
    
    static func image(_ image: UIImage?) -> Self {
        return .images(normal: image, highlighted: nil)
    }
    
    static func image(named name: String, in bundle: Bundle? = .none, compatibleWith traitCollection: UITraitCollection? = .none) -> Self {
        return .named(name, in: bundle, compatibleWith: traitCollection)
    }
    
    static func image(_ image: UIImage?, highlighted: UIImage?) -> Self {
        return .images(normal: image, highlighted: highlighted)
    }
}

public extension RowSystem {
    
    func icon(_ value: Binding<IconImage>) -> Self {
        var tempSelf = self
        tempSelf.icon = value.map { .image($0) }
        return self
    }
    
    func icon(_ value: IconImage) -> Self {
        var tempSelf = self
        tempSelf.icon = .constant(.image(value))
        return self
    }
}
