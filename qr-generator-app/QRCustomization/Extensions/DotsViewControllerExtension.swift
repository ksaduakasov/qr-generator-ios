//
//  DotsViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit
import QRCode
import Purchases

extension DotsViewController {
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
            make.top.equalTo(controlView.snp.bottom).offset(10)
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
    
    func setupFreeDotsCollectionView() {
        freeDotsCollectionView.dataSource = self
        freeDotsCollectionView.delegate = self
        freeDotsCollectionView.backgroundColor = .clear
        freeView.addSubview(freeDotsCollectionView)
        freeDotsCollectionView.snp.makeConstraints { make in
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
    
    func setupPaidDotsCollectionView() {
        paidDotsCollectionView.dataSource = self
        paidDotsCollectionView.delegate = self
        paidDotsCollectionView.backgroundColor = .clear
        paidView.addSubview(paidDotsCollectionView)
        paidDotsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DotsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == freeDotsCollectionView {
            return freePointPatterns.count
        }
        return paidPointPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == freeDotsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! DotsCell
            cell.imageView.image = UIImage(named: freePointPatterns[indexPath.item])
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! DotsCell
        cell.imageView.image = UIImage(named: paidPointPatterns[indexPath.item])
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == freeDotsCollectionView {
            let selectedPattern: QRCodePixelShapeGenerator = freePointClasses[indexPath.item]
            dotsSelected = freePointPatterns[indexPath.item]
            qrImageView.image = changeQRPattern(selectedPattern)
        } else {
            let purchase = KSPurchase()
            if !purchase.hasPremium() {
                let alert = purchase.showAlertToGetPremium()
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let selectedPattern: QRCodePixelShapeGenerator = paidPointClasses[indexPath.item]
                dotsSelected = paidPointPatterns[indexPath.item]
                qrImageView.image = changeQRPattern(selectedPattern)
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


