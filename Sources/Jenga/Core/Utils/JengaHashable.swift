import Foundation

public protocol JengaHashable {
    
    var hashValue: Int { get }
}

extension JengaHashable where Self: Any {
    
    @inlinable
    public var hashValue: Int { ObjectIdentifier(Self.Type.self).hashValue }
}

extension JengaHashable where Self: AnyObject {
    
    @inlinable
    public var hashValue: Int { ObjectIdentifier(self).hashValue }
}
