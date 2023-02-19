//
//  LogoViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit
import QRCode

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
            make.height.equalTo(20)
        }
    }
    
    func setupFunctionalView() {
        functionalView.backgroundColor = .systemGray6
        
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(view.bounds.height / 10)
            make.bottom.equalToSuperview()
            
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
    }
    
    func setupControlView() {
        controlView.backgroundColor = .white
        
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
            make.top.equalTo(freeLabel.snp.bottom)
            make.height.equalToSuperview().dividedBy(5)
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
    
    func setupPaidLogoCollectionView() {
        paidlogoCollectionView.dataSource = self
        paidlogoCollectionView.delegate = self
        paidlogoCollectionView.backgroundColor = .clear
        paidView.addSubview(paidlogoCollectionView)
        paidlogoCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension LogoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == freelogoCollectionView {
            return logoTemplates.count
        }
        return logoTemplates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == freelogoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
            cell.imageView.image = logoTemplates[indexPath.item]
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        if indexPath.item == 0 {
            cell.imageView.image = UIImage(systemName: "photo.circle")
        } else {
            cell.imageView.image = logoTemplates[indexPath.item]
        }
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == freelogoCollectionView {
            selectedLogo = logoTemplates[indexPath.row]
            qrImageView.image = QRWithLogo(logoTemplates[indexPath.row])
        }
        
        if indexPath.item == 0 {
            uploadImage()
        } else {
            selectedLogo = logoTemplates[indexPath.row]
            qrImageView.image = QRWithLogo(selectedLogo)
        }
        
    }
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1).cgColor
        let end = UIColor(red: 244/255, green: 245/255, blue: 248/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func uploadImage() {
        ImagePickerManager().pickImage(self) { image in
            self.selectedLogo = image
            self.qrImageView.image = self.QRWithLogo(image)
        }
    }
}
