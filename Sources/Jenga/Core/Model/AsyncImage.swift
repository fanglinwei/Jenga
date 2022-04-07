import Foundation
import UIKit

public protocol AsyncImage {
    
    var downloadURL: URL { get }
    
    func loadImage(with imageView: UIImageView?, _ completion: @escaping (Bool) -> Void)
}
