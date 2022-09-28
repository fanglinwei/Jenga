import UIKit

open class SpacerCell: UITableViewCell, ConfigurableCell {
    public typealias CellData = UIColor
    open func configure(with data: CellData) {
        contentView.backgroundColor = data
        backgroundColor = data
    }
}
