import UIKit
/// A enum that represents the image used in a row.
public enum Icon: Equatable {

    case image(Image)
    case async(AsyncImage)
    
    var image: Image? {
        switch self {
        case .image(let value):     return value
        default:                    return nil
        }
    }
    
    var async: AsyncImage? {
        switch self {
        case .async(let value):     return value
        default:                    return nil
        }
    }
}
