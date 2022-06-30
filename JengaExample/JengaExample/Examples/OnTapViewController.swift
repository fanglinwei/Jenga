//
//  OnTapViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/6/30.
//

import UIKit
import Jenga

class OnTapViewController: BaseViewController, DSLAutoTable {
    
    override var pageTitle: String { get { "OnTap 泛型支持" } }
    
    @State private var string: String = "123"
    
    var tableBody: [Table] {
        
        TableSection {
            NavigationRow<NavigationCell>("自定义 Navigation Cell")
                .height(52)
                .onTap { cell in
                    print(cell)
                }
            
            TableRow<BannerCell>(1993)
                .height(1184 / 2256 * (UIScreen.main.bounds.width - 40))
                .onTap { (view, data) in
                    print(view.id, data)
                }
            
            WrapperRow<BannerView>(1994)
                .height(1184 / 2256 * (UIScreen.main.bounds.width - 40))
                .onTap { (view, data) in
                    print(view.id, data)
                }
        }
    }
}

private extension OnTapViewController {
    
    class BannerView: UIView, TableRowView {
        
        private lazy var coverImageView = UIImageView(image: UIImage(named: "image1")!)
        
        let id: Int = 1993
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            addSubview(coverImageView)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            coverImageView.frame = bounds
        }

        func configure(with data: Int) {
            print(data)
        }
    }

    class BannerCell: UITableViewCell, ConfigurableCell {
        
        private lazy var coverImageView = UIImageView(image: UIImage(named: "image2")!)
        
        let id: Int = 1994
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            addSubview(coverImageView)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            coverImageView.frame = bounds
        }
        
        func configure(with data: Int) {
            print(data)
        }
    }

    class NavigationCell: UITableViewCell {
        
    }
}

