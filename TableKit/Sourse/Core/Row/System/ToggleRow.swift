//
//  ToggleRow.swift
//  QuickTableViewController
//
//  Created by Ben on 01/09/2015.
//  Copyright (c) 2015 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

/// A class that represents a row with a switch.
open class ToggleRow<Cell: ToggleCell>: BasicRow<Cell>, ToggleRowCompatible, Equatable {
    
    // MARK: - Initializer
    
    /// Initializes a `ToggleRow` with a title, a switch state and an action closure.
    /// The detail text, icon and the customization closure are optional.
    public init(_ text: Binding<String>, isOn: Binding<Bool>) {
        self.isOn = isOn
        super.init(text)
    }
    
    public init(_ text: String, isOn: Binding<Bool>) {
        self.isOn = isOn
        super.init(text)
    }
    
    // MARK: - SwitchRowCompatible
    
    /// The state of the switch.
    public var isOn: Binding<Bool>
    
    public var onTap: ((Bool) -> Void)?
    
    open override func configure(_ cell: UITableViewCell) {
        super.configure(cell)
        (cell as? Cell)?.configure(with: (isOn, onTap))
    }
    
    /// The `SwitchRow` should not be selectable.
    public override var isSelectable: Bool {
        get { false }
        set {}
    }
    
    // MARK: - Equatable
    
    /// Returns true iff `lhs` and `rhs` have equal titles, detail texts, switch values, and icons.
    public static func == (lhs: ToggleRow, rhs: ToggleRow) -> Bool {
        return lhs.text == rhs.text &&
        lhs.detailText == rhs.detailText &&
        lhs.isOn == rhs.isOn &&
        lhs.icon == rhs.icon
    }
}

extension ToggleRow {
    
    func isOn(_ value: Bool) -> Self {
        self.isOn = .constant(value)
        return self
    }
    
    /// Toggle click
    func onTap(_ value: @escaping (Bool) -> Void) -> Self {
        self.onTap = value
        return self
    }
    
    func onTap<S>(on target: S, _ value: @escaping (S, Bool) -> Void) -> Self where S: AnyObject {
        self.onTap = { [weak target] isOn in
            guard let target = target else { return }
            value(target, isOn)
        }
        return self
    }
    
}
