import Foundation

public protocol Table { }

extension BacicSection: Table { }
extension TableHeader: Table { }
extension TableFooter: Table { }
extension TableSpacer: Table { }

extension BasicRow: Table { }
extension TableRow: Table { }
extension SpacerRow: Table { }
