import UIKit

public protocol Spacer {
    
    var height: CGFloat { get }
    
    var color: UIColor { get set }
}

public struct TableSpacer: Spacer {
    
    public let height: CGFloat
    
    public var color: UIColor = .clear
    
    public init(_ height: CGFloat = 10, color: UIColor = .clear) {
        self.height = height
        self.color = color
    }
}

extension TableSpacer: Reform { }

public extension TableSpacer {
    
    func color(_ value: UIColor) -> Self {
        reform { $0.color = value }
    }
}
