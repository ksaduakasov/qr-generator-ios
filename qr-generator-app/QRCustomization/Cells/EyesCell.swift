//
//  EyesCell.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 11.02.2023.
//

import UIKit
import SnapKit

class EyesCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        
    }
}
