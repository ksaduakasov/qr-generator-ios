//
//  CollectionViewCell.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 16.02.2023.
//

import UIKit

class OptionsCell: UICollectionViewCell {
    var isActive: Bool = false {
        didSet {
            layer.borderWidth = isActive ? 3 : 0
            layer.borderColor = isActive ? UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1).cgColor : UIColor.clear.cgColor
        }
    }
    
    let imageLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension OptionsCell {
    func setupView() {
        contentView.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2)
        }
        
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
    }
}
