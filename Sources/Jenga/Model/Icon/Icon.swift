import UIKit
/// A enum that represents the image used in a row.
public enum Icon {
    case image(Image)
    case async(AsyncImage)
    
    public var image: Image? {
        switch self {
        case .image(let value):     return value
        default:                    return nil
        }
    }
    
    public var async: AsyncImage? {
        switch self {
        case .async(let value):     return value
        default:                    return nil
        }
    }
}
