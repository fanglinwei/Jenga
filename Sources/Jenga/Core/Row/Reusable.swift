import UIKit

extension UITableViewCell: Reusable {}

internal protocol Reusable {
    static var reuseIdentifier: String { get }
}

internal extension Reusable {
    
    static var reuseIdentifier: String {
        let type = String(describing: self)
        return type.matches(of: String.typeDescriptionPattern).last ?? type
    }
}

internal extension String {
    
    static var typeDescriptionPattern: String {
        // For the types in the format of "(CustomCell in _B5334F301B8CC6AA00C64A6D)"
        return "^\\(([\\w\\d]+)\\sin\\s_[0-9A-F]+\\)$"
    }
    
    func matches(of pattern: String) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
#if swift(>=3.2)
        let fullText = NSRange(location: 0, length: count)
#else
        let fullText = NSRange(location: 0, length: characters.count)
#endif
        
        guard let matches = regex?.matches(in: self, options: [], range: fullText) else {
            return []
        }
        
        return matches.reduce([]) { accumulator, match in
            accumulator + (0..<match.numberOfRanges).map {
#if swift(>=4)
                return (self as NSString).substring(with: match.range(at: $0))
#else
                return (self as NSString).substring(with: match.rangeAt($0))
#endif
            }
        }
    }
}
