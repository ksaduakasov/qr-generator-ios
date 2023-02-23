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
    
    func setupColorSelectionSegmentedControl() {
        anotherSegment.type = .normal
        anotherSegment.selectorType = .bottomBar
        anotherSegment.buttonTitles = "Foreground, Background"
        anotherSegment.textColor = .white
        anotherSegment.selectorTextColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        anotherSegment.selectorColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        anotherSegment.SelectedFont = UIFont(name: "ChalkboardSE-Bold", size: 15)!
        anotherSegment.normalFont = UIFont(name: "ChalkboardSE-Regular", size: 15)!
        anotherSegment.selectedSegmentIndex = 0
        
        controlView.addSubview(anotherSegment)
        anotherSegment.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
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
    
    func setupColorsCollectionView() {
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        colorsCollectionView.backgroundColor = .clear
        freeView.addSubview(colorsCollectionView)
        
        colorsCollectionView.snp.makeConstraints { make in
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
    
    
    func setupPickerButton() {
        functionalView.addSubview(pickerButton)
        
        pickerButton.snp.makeConstraints { make in
            make.top.equalTo(paidLabel.snp.bottom).offset(20)
            make.height.equalToSuperview().dividedBy(7)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.8)
        }
    }
}

extension ColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            cell.backgroundColor = colors[indexPath.item]
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.black.cgColor
            return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.row]
        switch (anotherSegment.selectedSegmentIndex)  {
        case 0:
            foregroundColor = selectedColor
        case 1:
            backgroundColor = selectedColor
        default:
            backgroundColor = UIColor.white
            foregroundColor = UIColor.black
        }
        qrImageView.image = changeQRColor(backgroundColor, foregroundColor)
        textView.backgroundColor = backgroundColor
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
    
    func gradientColor(start: UIColor, end: UIColor) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [start.cgColor, end.cgColor]
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
}

extension ColorViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor as UIColor
        switch (anotherSegment.selectedSegmentIndex)  {
        case 0:
            foregroundColor = color
        case 1:
            backgroundColor = color
        default:
            backgroundColor = UIColor.white
            foregroundColor = UIColor.black
        }
        qrImageView.image = changeQRColor(backgroundColor, foregroundColor)
        textView.backgroundColor = backgroundColor
    }
}


extension ColorViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


