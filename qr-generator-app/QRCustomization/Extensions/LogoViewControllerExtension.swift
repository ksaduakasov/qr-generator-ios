//
//  LogoViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit
import QRCode
import Purchases

extension LogoViewController {
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
            make.height.equalToSuperview().dividedBy(7)
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
    
    func setupRemoveLogoButton() {
        controlView.addSubview(removeLogoButton)
        
        removeLogoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
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
            make.height.equalToSuperview().dividedBy(7)
        }
    }
    
    func setupFreeLogoCollectionView() {
        freelogoCollectionView.dataSource = self
        freelogoCollectionView.delegate = self
        freelogoCollectionView.backgroundColor = .clear
        freeView.addSubview(freelogoCollectionView)
        freelogoCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupPickerButton() {
        functionalView.addSubview(pickerButton)
        
        pickerButton.snp.makeConstraints { make in
            make.top.equalTo(freeView.snp.bottom).offset(30)
            make.height.equalToSuperview().dividedBy(7)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.8)
        }
    }
}


extension LogoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return freeLogoTemplates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        cell.imageView.image = freeLogoTemplates[indexPath.item]
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let purchase = KSPurchase()
        if !purchase.hasPremium() {
            let alert = purchase.showAlertToGetPremium()
            self.present(alert, animated: true, completion: nil)
            
        } else {
            selectedLogo = freeLogoTemplates[indexPath.row]
            qrImageView.image = QRWithLogo(freeLogoTemplates[indexPath.row])
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
