//
//  EyesViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit
import QRCode

extension EyesViewController {
    func setupQRImageView() {
        qrImageView.image = generateQRCode(from: data)
        view.addSubview(qrImageView)
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
    }
    
    func setupTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(35)
        }
    }
    
    func setupTextLabel() {
        textView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func setupFunctionalView() {
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
    }
    
    func setupControlView() {
        functionalView.addSubview(controlView)
        controlView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
        }
    }
    
    func setupDiscardButton() {
        controlView.addSubview(discardButton)
        
        discardButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(50)
            make.top.bottom.equalToSuperview()
            
        }
    }
    
    func setupConfirmButton() {
        controlView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(50)
            make.top.bottom.equalToSuperview()
            
        }
    }
    
    func setupEyesCollectionView() {
        eyesCollectionView.dataSource = self
        eyesCollectionView.delegate = self
        functionalView.addSubview(eyesCollectionView)
        
        eyesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview().inset(30)
        }
    }
}


extension EyesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eyesPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        cell.imageView.image = UIImage(named: eyesPatterns[indexPath.item])
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pattern: QRCodeEyeShapeGenerator = eyesClasses[indexPath.item]
        eyesSelected = eyesPatterns[indexPath.item]
        qrImageView.image = changeQRPattern(pattern)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}

