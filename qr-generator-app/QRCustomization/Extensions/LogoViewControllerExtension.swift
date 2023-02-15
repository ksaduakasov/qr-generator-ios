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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
    }
    
    func setupFunctionalView() {
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(10)
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
    
    func setupLogoCollectionView() {
        logoCollectionView.dataSource = self
        logoCollectionView.delegate = self
        functionalView.addSubview(logoCollectionView)
        
        logoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview().inset(30)
        }
    }
}


extension LogoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logoTemplates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        if indexPath.row == 0 {
            cell.imageView.image = UIImage(systemName: "nosign")
        } else {
            cell.imageView.image = UIImage(named: logoTemplates[indexPath.item])
        }
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectedLogo = nil
            qrImageView.image = QRWithLogo("")
        } else {
            selectedLogo = UIImage(named: logoTemplates[indexPath.row])
            qrImageView.image = QRWithLogo(logoTemplates[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
