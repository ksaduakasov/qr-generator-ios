//
//  WelcomeViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit


extension WelcomeViewController {
    func setupNavigationItems() {
        let historyButton = UIBarButtonItem(image: UIImage(systemName: "archivebox.circle.fill"), style: .plain, target: self, action: #selector(openHistory))
        historyButton.tintColor = .white
        navigationItem.rightBarButtonItem = historyButton

    }
    
    
    func setupButton() {
        createQRView.backgroundColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        createQRView.layer.cornerRadius = view.bounds.width / 20
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToSelection))
        createQRView.addGestureRecognizer(tapGesture)
        createQRView.isUserInteractionEnabled = true
        view.addSubview(createQRView)
        
        createQRView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalTo(createQRView.snp.width)
        }
    }
    
    func setupButtonImage() {
        createQRView.addSubview(buttonImageView)
        buttonImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalTo(buttonImageView.snp.height)
        }
    }
    
    
    func setupButtonLabel() {
        createQRView.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupHistoryButton() {
        view.addSubview(historyButton)
        historyButton.snp.makeConstraints { make in
            make.top.equalTo(createQRView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }
    
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 50/255, green: 47/255, blue: 82/255, alpha: 1).cgColor
        let end = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
