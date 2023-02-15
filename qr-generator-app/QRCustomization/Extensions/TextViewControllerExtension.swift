//
//  TextViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit

extension TextViewController {
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
    
    func setupTextViewColor() {
        let colorData = realmData.realm.objects(QRCodeColor.self)
        if colorData.count != 0 {
            let color = colorData.first!
            textView.backgroundColor = UIColor(hexString: color.backgroundColor)
        } else {
            textView.backgroundColor = .white
        }
        view.backgroundColor = .white
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
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(30)
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
    
    func setupTextField() {
        functionalView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupColorView() {
        functionalView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom)
            make.height.equalTo(100)
        }
    }
    
    func setupFontView() {
        functionalView.addSubview(fontView)
        fontView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(colorView.snp.bottom).offset(10)
            make.height.equalTo(160)

        }
    }
    
    func setupColorLabel() {
        colorView.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
    }
    
    func setupFontColorCollectionView() {
        fontColorCollectionView.dataSource = self
        fontColorCollectionView.delegate = self
        colorView.addSubview(fontColorCollectionView)
        fontColorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(65)
        }
    }
    
    func setupFontLabel() {
        fontView.addSubview(fontLabel)
        fontLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
    }
    
    func setupFontCollectionView() {
        fontCollectionView.dataSource = self
        fontCollectionView.delegate = self
        fontView.addSubview(fontCollectionView)
        fontCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fontLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(135)
        }
    }
}

extension TextViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fontColorCollectionView {
            return colors.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fontColorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontColorCell", for: indexPath) as! FontColorCell
            cell.backgroundColor = colors[indexPath.item]
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontCell", for: indexPath) as! FontCell
        cell.fontLabel.text = fontTypes[indexPath.item]
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == fontColorCollectionView {
            selectedTextColor = colors[indexPath.row]
            textLabel.textColor = selectedTextColor
        } else if collectionView == fontCollectionView {
            selectedTextFont = UIFont(name: fontTypes[indexPath.row], size: 20)!
            textLabel.font = selectedTextFont
        }
        
    }
    
}

extension TextViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        enteredText = updatedText
        print(enteredText)
        textLabel.text = enteredText
        textView.isHidden = enteredText.isEmpty
        return true
    }
}
