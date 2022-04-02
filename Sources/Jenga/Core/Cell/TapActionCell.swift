import UIKit

/// A `UITableViewCell` subclass with the title text center aligned.
open class TapActionCell: UITableViewCell, ConfigurableCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUpAppearance()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpAppearance()
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        textLabel?.textColor = row?.text.color.wrappedValue ?? tintColor
    }
    
    private func setUpAppearance() {
        textLabel?.numberOfLines = 0
        textLabel?.textAlignment = .center
    }
    
    private var row: TapActionRowCompatible?
    open func configure(with row: Row) {
        guard let row = row as? TapActionRowCompatible else {
            return
        }
        self.row = row
        textLabel?.textAlignment = row.textAlignment
    }
}
