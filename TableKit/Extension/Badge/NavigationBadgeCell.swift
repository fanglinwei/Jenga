//
//  NavigationBadgeCell.swift
//  Zunion
//
//  Created by 方林威 on 2022/3/11.
//

import UIKit

public class NavigationBadgeCell: UITableViewCell, ConfigurableCell {
    
    private lazy var badgeView: BadgeView = {
        $0.layer.addShadow(ofColor: BadgeView.defaultBadgeColor, radius: 3, offset: .init(width: 0, height: 3), opacity: 0.3)
        return $0
    }(BadgeView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        contentView.addSubview(badgeView)
        badgeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        badgeView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let row = row  else { return }
        switch row.cellStyle {
        case .value1 where row.accessoryType == .disclosureIndicator:
            let frame = detailTextLabel?.frame ?? .zero
            
            let x: CGFloat
            if let badge = badgeView.badgeValue {
                
                let offset: CGFloat = badge == "" ? 20 : 18
                x = contentView.bounds.width - frame.width - offset
                    
            } else {
                x = frame.minX
            }
            
            detailTextLabel?.frame = CGRect(
                x: x,
                y: frame.minY,
                width: frame.width,
                height: frame.height
            )
            
        default:
            break
        }
    }
    
    private weak var row: BadgeRowCompatible?
    open func configure(with row: Row) {
        guard let row = row as? BadgeRowCompatible else {
            return
        }
        self.row = row
        row.badgeValue.append(observer: row) { [weak self] change in
            self?.badgeView.badgeValue = change.new
        }
        row.badgeColor?.append(observer: row) { [weak self] change in
            self?.badgeView.badgeColor = change.new
            self?.badgeView.layer.addShadow(ofColor: change.new, radius: 3, offset: .init(width: 0, height: 3), opacity: 0.3)
        }
    }
}

fileprivate class BadgeView: UIView {
    
    /// 默认颜色
    public static var defaultBadgeColor: UIColor = .red
    
    /// Badge color
    open var badgeColor: UIColor? = defaultBadgeColor {
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }
    
    /// Badge value, supprot nil, "", "1", "someText". Hidden when nil. Show Little dot style when "".
    open var badgeValue: String? {
        didSet {
            badgeLabel.text = badgeValue
        }
    }
    
    /// Image view
    open var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    /// 显示badgeValue的Label
    open var badgeLabel: UILabel = {
        let badgeLabel = UILabel.init(frame: CGRect.zero)
        badgeLabel.backgroundColor = .clear
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 13.0)
        badgeLabel.textAlignment = .center
        return badgeLabel
    }()
    
    /// Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(badgeLabel)
        self.imageView.backgroundColor = badgeColor
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     *  通过layoutSubviews()布局子视图，你可以通过重写此方法实现自定义布局。
     **/
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let badgeValue = badgeValue else {
            imageView.isHidden = true
            badgeLabel.isHidden = true
            return
        }
        
        imageView.isHidden = false
        badgeLabel.isHidden = false
        
        if badgeValue == "" {
            let w : CGFloat = 6
            imageView.frame = CGRect(origin: CGPoint(x: (bounds.size.width - w) / 2.0, y: (bounds.size.height - w) / 2.0), size: CGSize.init(width: w, height: w))
        } else {
            imageView.frame = bounds
        }
        imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0
        badgeLabel.sizeToFit()
        badgeLabel.center = imageView.center
    }
    
    override var intrinsicContentSize: CGSize {
        guard let _ = badgeValue else {
            return CGSize(width: 18.0, height: 18.0)
        }
        let textSize = badgeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(18.0, textSize.width + 10.0), height: 18.0)
    }
    
    /*
     *  通过此方法计算badge视图需要占用父视图的frame大小，通过重写此方法可以自定义badge视图的大小。
     *  如果你需要自定义badge视图在Content中的位置，可以设置Content的badgeOffset属性。
     */
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let _ = badgeValue else {
            return CGSize(width: 18.0, height: 18.0)
        }
        let textSize = badgeLabel.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: max(18.0, textSize.width + 10.0), height: 18.0)
    }
    
}

extension CALayer {
    
    func addShadow(ofColor color: UIColor,
                   radius: CGFloat = 3,
                   offset: CGSize = .zero,
                   opacity: Float = 1) {
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = opacity
        masksToBounds = false
    }
}
