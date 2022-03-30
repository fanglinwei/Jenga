import UIKit

/// A `UITableViewCell` subclass with the title text center aligned.
open class TapActionCell: UITableViewCell, ConfigurableCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpAppearance()
    }
    
    /**
     Overrides the designated initializer that returns an object initialized from data in a given unarchiver.
     
     - parameter aDecoder: An unarchiver object.
     
     - returns: `self`, initialized using the data in decoder.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpAppearance()
    }
    
    // MARK: UIView
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        textLabel?.textColor = row?.text.color.wrappedValue ?? tintColor
    }
    
    // MARK: Private Methods
    
    private func setUpAppearance() {
        textLabel?.numberOfLines = 0
        textLabel?.textAlignment = .center
    }
    
    private weak var row: TapActionRowCompatible?
    
    open func configure(with row: Row) {
        guard let row = row as? TapActionRowCompatible else {
            return
        }
        self.row = row
        textLabel?.textAlignment = row.textAlignment
    }
}
