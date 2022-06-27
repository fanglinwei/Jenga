//
//  WrapperViewRowCell.swift
//  Jenga
//
//  Created by 方林威 on 2022/6/15.
//

import UIKit

public class WrapperViewRowCell<View: TableRowView>: UITableViewCell {
    public let view: View
    
    public var edgeInsets: UIEdgeInsets = .zero {
        didSet {
            guard edgeInsets != oldValue else { return }
            setNeedsLayout()
        }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.view = View()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(view)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        view.frameWithoutTransform = bounds.inset(by: edgeInsets)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let _edgeInsets = UIEdgeInsets(top: -edgeInsets.top, left: -edgeInsets.left, bottom: -edgeInsets.bottom, right: -edgeInsets.right)
        return view.sizeThatFits(size.inset(by: edgeInsets)).inset(by: _edgeInsets)
    }
}

extension WrapperViewRowCell: ConfigurableCell {
    
    public func configure(with data: View.Data) {
        view.configure(with: data)
    }
}

public protocol TableRowView: UIView {
    associatedtype Data
    func configure(with data: Data)
}

fileprivate extension UIView {
    
    var frameWithoutTransform: CGRect {
        get { CGRect(center: center, size: bounds.size) }
        set {
            bounds.size = newValue.size
            center = newValue.offsetBy(
                dx: bounds.width * (layer.anchorPoint.x - 0.5),
                dy: bounds.height * (layer.anchorPoint.y - 0.5)
            ).center
        }
    }
}

fileprivate extension CGRect {
    
    var center: CGPoint { CGPoint(x: midX, y: midY) }
    
    init(center: CGPoint, size: CGSize) {
        let right = CGSize(width: size.width / 2, height: size.height / 2)
        let origin = CGPoint(x: center.x - right.width, y: center.y - right.height)
        self.init(origin: origin, size: size)
    }
}

fileprivate extension CGSize {
    
    func inset(by insets: UIEdgeInsets) -> CGSize {
        CGSize(width: width - insets.left - insets.right, height: height - insets.top - insets.bottom)
    }
}

