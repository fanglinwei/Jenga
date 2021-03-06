//
//  BannerCell.swift
//  TableKit
//
//  Created by 方林威 on 2022/3/25.
//

import UIKit
import Jenga

protocol BannerCellDelegate: NSObjectProtocol {
    
    func bannerOpenAction()
}

class BannerCell: UITableViewCell {
    
    weak var delegate: BannerCellDelegate?
    
    private lazy var coverImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(coverImageView)
        coverImageView.fillToSuperview()
        
        coverImageView.layer.cornerRadius = 10
        coverImageView.layer.masksToBounds = true
        
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverAction)))
    }
    
    @objc
    private func coverAction() {
        delegate?.bannerOpenAction()
    }
}

extension BannerCell: ConfigurableCell {
    typealias Data = String
    
    func configure(with data: Data) {
        coverImageView.image = .init(named: data)
    }
}
