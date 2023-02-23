//
//  LinearGradient.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 21.02.2023.
//

import UIKit

class DiagonalGradient: UIView {

    let gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame:frame)
        setupGradient(color: UIColor.red)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient(color: UIColor.red)
    }
    
    func setupGradient(color: UIColor ) {
        
        gradient.colors = [
            UIColor.clear.cgColor,
            color.cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = bounds
        
        layer.addSublayer(gradient)
    
    }
}
