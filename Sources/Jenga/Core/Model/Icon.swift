import UIKit
/// A enum that represents the image used in a row.
public enum Icon {
    case image(Image)
    case async(AsyncImage)
}

extension Icon: Hashable {
    
    public static func == (lhs: Icon, rhs: Icon) -> Bool {
        switch (lhs, rhs) {
        case (.image(let r1), .image(let r2)):          return r1.image == r2.image && r1.highlightedImage == r2.highlightedImage
        case (.async(let r1), .async(let r2)):          return r1.downloadURL == r2.downloadURL
        case (.image, .async):                          return false
        case (.async, .image):                          return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .image(let r):
            hasher.combine(r.image)
            hasher.combine(r.highlightedImage)
        case .async(let p):
            hasher.combine(p.downloadURL)
        }
    }
}

extension Icon {
    
    public var asImage: Image? {
        switch self {
        case .image(let value):     return value
        default:                    return nil
        }
    }
    
    public var asAsync: AsyncImage? {
        switch self {
        case .async(let value):     return value
        default:                    return nil
        }
    }
}
