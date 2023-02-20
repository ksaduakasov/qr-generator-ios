//
//  QRPreviewViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 21.02.2023.
//

import Foundation
import UIKit

extension QRPreviewViewController {
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1).cgColor
        let end = UIColor(red: 244/255, green: 245/255, blue: 248/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        view.layer.addSublayer(gradientLayer)
        
    }
    
    func setupNavigationItems() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.black
        let createButton = UIBarButtonItem(image: UIImage(systemName: "house.fill"), style: .plain, target: self, action: #selector(homeButtonTapped))
        createButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = createButton
        navigationItem.titleView = titleLabel
    }
    
    func setupQRImage() {
        view.addSubview(qrImageView)
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.bounds.height/15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalTo(qrImageView.snp.width)
        }
    }
    
    func setupToolsLabel() {
        view.addSubview(toolsLabel)
        toolsLabel.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupShareButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shareButtonTapped))
        shareButton.addGestureRecognizer(tapGesture)
        shareButton.isUserInteractionEnabled = true
        
        shareButton.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        shareButton.layer.cornerRadius = view.bounds.width / 14
        shareButton.layer.masksToBounds = true
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(toolsLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().dividedBy(7)
            make.height.equalTo(shareButton.snp.width)
            make.centerX.equalToSuperview().offset(-50)
        }
        
        shareButton.addSubview(shareImageView)
        shareImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func setupShareLabel() {
        view.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(-50)
        }
    }
    
    func setupQRSaveButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveQRButton.addGestureRecognizer(tapGesture)
        saveQRButton.isUserInteractionEnabled = true
        
        saveQRButton.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        saveQRButton.layer.cornerRadius = view.bounds.width / 14
        saveQRButton.layer.masksToBounds = true
        view.addSubview(saveQRButton)
        saveQRButton.snp.makeConstraints { make in
            make.top.equalTo(toolsLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().dividedBy(7)
            make.height.equalTo(saveQRButton.snp.width)
            make.centerX.equalToSuperview().offset(50)
        }
        
        saveQRButton.addSubview(saveImageView)
        saveImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func setupQRSaveLabel() {
        view.addSubview(saveLabel)
        saveLabel.snp.makeConstraints { make in
            make.top.equalTo(saveQRButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(50)
        }
    }
}
