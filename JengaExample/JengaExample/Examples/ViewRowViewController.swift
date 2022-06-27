//
//  ViewRowViewController.swift
//  JengaExample
//
//  Created by 方林威 on 2022/6/15.
//

import UIKit
import Jenga

class ViewRowViewController: BaseViewController, DSLAutoTable {
    
    override var pageTitle: String { get { "WrapperRow" } }
    
    @State private var string: String = "123"
    
    var tableBody: [Table] {
        
        TableSection {
            WrapperRow<BannerView>(123)
                .height(1184 / 2256 * (UIScreen.main.bounds.width - 40))
            
            WrapperRow<UILabel>("456")
                .customize { label, data in
                    label.text = "\(data)"
                    label.numberOfLines = 0
                }
        }
    }
}

fileprivate class BannerView: UIView, TableRowView {
    
    private lazy var coverImageView = UIImageView(image: UIImage(named: "image1")!)
    
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
    
    typealias Data = Int
    
    func configure(with data: Data) {
        print("===============")
        print(data)
    }
}

