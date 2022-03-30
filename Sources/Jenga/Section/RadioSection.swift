import Foundation

/// TODO: 功能待开发
open class RadioSection: BacicSection {
    
    // MARK: - Initializer
    
    /// Initializes a section with a title, containing rows and an optional footer.
    public init(@ArrayBuilder<OptionRowCompatible> builder: ArrayBuilder<OptionRowCompatible>.ContentBlock) {
        self.options = builder()
        super.init()
    }
    
    public init(_ rows: [OptionRowCompatible]) {
        self.options = rows
        super.init()
    }
    
    // MARK: - Section
    
    /// The array of rows in the section.
    open override var rows: [Row] {
        get {
            return options
        }
        set {
            options = newValue as? [OptionRowCompatible] ?? options
        }
    }
    
    // MARK: - RadioSection
    
    /// A boolean that indicates whether there's always one option selected.
    open var alwaysSelectsOneOption: Bool = false {
        didSet {
            if alwaysSelectsOneOption && selectedOption == nil {
                options.first?.isSelected = true
            }
        }
    }
    
    /// The array of options in the section. It's identical to the `rows`.
    open private(set) var options: [OptionRowCompatible]
    
    /// Returns the selected index, or nil when nothing is selected.
    open var indexOfSelectedOption: Int? {
        return options.firstIndex { $0.isSelected }
    }
    
    /// Returns the selected option row, or nil when nothing is selected.
    open var selectedOption: OptionRowCompatible? {
        if let index = indexOfSelectedOption {
            return options[index]
        } else {
            return nil
        }
    }
    
    /// Toggle the selection of the given option and keep options mutually exclusive.
    /// If `alwaysSelectOneOption` is set to true, it will not deselect the current selection.
    ///
    /// - Parameter option: The option to flip the `isSelected` state.
    /// - Returns: The indexes of changed options.
    open func toggle(_ option: OptionRowCompatible) -> IndexSet {
        if option.isSelected && alwaysSelectsOneOption {
            return []
        }
        
        defer {
            option.isSelected = !option.isSelected
        }
        
        if option.isSelected {
            // Deselect the selected option.
            return options.firstIndex(where: { $0 === option }).map { [$0] } ?? []
        }
        
        var toggledIndexes: IndexSet = []
        
        for (index, element) in options.enumerated() {
            switch element {
            case let target where target === option:
                toggledIndexes.insert(index)
            case _ where element.isSelected:
                toggledIndexes.insert(index)
                element.isSelected = false
            default:
                break
            }
        }
        
        return toggledIndexes
    }
}
