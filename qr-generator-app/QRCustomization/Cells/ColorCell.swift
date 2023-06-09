//
//  ColorCell.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit
import GradientView

class ColorCell: UICollectionViewCell {
    let colorView = GradientView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView.backgroundColor = .clear
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
