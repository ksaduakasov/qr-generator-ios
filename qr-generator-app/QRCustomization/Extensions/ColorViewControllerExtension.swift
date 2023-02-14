//
//  ColorViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit

extension ColorViewController {
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
    
    func setupColorSelectionSegmentedControl() {
        controlView.addSubview(colorSelectionSegmentedControl)
        colorSelectionSegmentedControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func setupcolorsCollectionView() {
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        functionalView.addSubview(colorsCollectionView)
        
        colorsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview().inset(30)
        }
    }
}

extension ColorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.backgroundColor = colors[indexPath.item]
        cell.color = colors[indexPath.item]
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.row]
        switch (colorSelectionSegmentedControl.selectedSegmentIndex)  {
        case 0:
            foregroundColor = selectedColor
        case 1:
            backgroundColor = selectedColor
        default:
            backgroundColor = UIColor.white
            foregroundColor = UIColor.black
        }
        qrImageView.image = changeQRColor(backgroundColor, foregroundColor)
    }
}


