//
//  FontCell.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit

class FontCell: UICollectionViewCell {
    var fontLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        fontLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fontLabel)
        
        fontLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
        }
    }
}
