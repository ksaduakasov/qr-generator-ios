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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.bounds.height/15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalTo(qrImageView.snp.width)
        }
    }
    
    func setupTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom)
            make.left.equalTo(qrImageView.snp.left)
            make.right.equalTo(qrImageView.snp.right)
            make.height.equalTo(qrImageView.snp.height).dividedBy(10)
        }
    }
    
    func setupTextLabel() {
        textView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func setupFunctionalView() {
        functionalView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(view.bounds.height / 10)
            make.bottom.equalToSuperview()
            
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
    }
    
    func setupControlView() {
        controlView.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        functionalView.addSubview(controlView)
        controlView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(8)
            make.left.right.equalToSuperview()
        }
    }
    
    func setupDiscardButton() {
        controlView.addSubview(discardButton)
        
        discardButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
            
        }
    }
    
    func setupConfirmButton() {
        controlView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
            
        }
    }
    
    func setupFreeLabel() {
        functionalView.addSubview(freeLabel)
        freeLabel.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupFreeView() {
        freeView.backgroundColor = .clear
        functionalView.addSubview(freeView)
        freeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(freeLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().dividedBy(5)
        }
    }
    
    func setupFreeEyesCollectionView() {
        freeEyesCollectionView.dataSource = self
        freeEyesCollectionView.delegate = self
        freeEyesCollectionView.backgroundColor = .clear
        freeView.addSubview(freeEyesCollectionView)
        freeEyesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupPaidLabel() {
        functionalView.addSubview(paidLabel)
        paidLabel.snp.makeConstraints { make in
            make.top.equalTo(freeView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupPaidView() {
        paidView.backgroundColor = .clear
        functionalView.addSubview(paidView)
        paidView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(paidLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            
        }
    }
    
    func setupPaidEyesCollectionView() {
        paidEyesCollectionView.dataSource = self
        paidEyesCollectionView.delegate = self
        paidEyesCollectionView.backgroundColor = .clear
        paidView.addSubview(paidEyesCollectionView)
        paidEyesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension EyesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == freeEyesCollectionView {
            return freeEyesPatterns.count
        }
        return paidEyesPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == freeEyesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
            cell.imageView.image = UIImage(named: freeEyesPatterns[indexPath.item])
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        cell.imageView.image = UIImage(named: paidEyesPatterns[indexPath.item])
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == freeEyesCollectionView {
            let pattern: QRCodeEyeShapeGenerator = freeEyesClasses[indexPath.item]
            eyesSelected = freeEyesPatterns[indexPath.item]
            qrImageView.image = changeQRPattern(pattern)
        } else {
            if !storeKit.isPurchasedEyes {
                let alert = showAlert()
                self.present(alert, animated: true, completion: nil)
            } else {
                let pattern: QRCodeEyeShapeGenerator = paidEyesClasses[indexPath.item]
                eyesSelected = paidEyesPatterns[indexPath.item]
                qrImageView.image = changeQRPattern(pattern)
            }

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

