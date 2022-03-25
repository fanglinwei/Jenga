import UIKit

/// A `UITableViewCell` subclass that shows a `UISwitch` as the `accessoryView`.
open class ToggleCell: UITableViewCell, ConfigurableCell {

    public private(set) lazy var switchControl = UISwitch()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpAppearance()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpAppearance()
    }
    
    open func configure(with data: (isOn: Binding<Bool>, onTap: ((Bool) -> Void)?)) {
        switchControl.isOn(binding: data.isOn) { isOn in
            data.onTap?(isOn)
        }
        accessoryView = switchControl
    }
    
    private func setUpAppearance() {
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
    }
    
}
