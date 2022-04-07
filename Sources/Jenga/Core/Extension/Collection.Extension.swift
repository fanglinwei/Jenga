import Foundation
import UIKit

internal extension Collection {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

internal extension Optional where Wrapped: Collection {

    /// Check if optional is nil or empty collection.
    var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }

    /// Returns the collection only if it is not nill and not empty.
    var nonEmpty: Wrapped? {
        guard let collection = self else { return nil }
        guard !collection.isEmpty else { return nil }
        return collection
    }
}

internal extension Optional where Wrapped == CGFloat {
    
    var nonEfficient: Wrapped? {
        guard let float = self else { return nil }
        guard float != UITableView.highAutomaticDimension else { return nil }
        guard float != 0 else { return nil }
        return float
    }
}
