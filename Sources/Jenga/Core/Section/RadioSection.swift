import Foundation

/// TODO: 功能待开发
open class RadioSection: BacicSection {
    
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
    
    open var alwaysSelectsOneOption: Bool = false {
        didSet {
            if alwaysSelectsOneOption && selectedOption == nil {
                options.first?.isSelected = true
            }
        }
    }
    
    open private(set) var options: [OptionRowCompatible]
    
    open var indexOfSelectedOption: Int? {
        return options.firstIndex { $0.isSelected }
    }
    
    open var selectedOption: OptionRowCompatible? {
        if let index = indexOfSelectedOption {
            return options[index]
        } else {
            return nil
        }
    }
    
    open func toggle(_ option: OptionRowCompatible) -> IndexSet {
        if option.isSelected && alwaysSelectsOneOption {
            return []
        }
        
        defer {
            option.isSelected = !option.isSelected
        }
        
        if option.isSelected {
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
