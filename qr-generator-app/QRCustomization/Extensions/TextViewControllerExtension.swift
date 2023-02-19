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
        functionalView.backgroundColor = .systemGray6
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(view.bounds.height / 10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
    }
    
    func setupControlView() {
        controlView.backgroundColor = .white
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
    
    func setupTextField() {
        functionalView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(30)
            make.height.equalToSuperview().dividedBy(9)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupColorLabel() {
        functionalView.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
    
    func setupColorView() {
        colorView.backgroundColor = .systemGray6
        functionalView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(colorLabel.snp.bottom).offset(5)
            make.height.equalToSuperview().dividedBy(7)
        }
    }
    
    
    func setupFontColorCollectionView() {
        fontColorCollectionView.dataSource = self
        fontColorCollectionView.delegate = self
        fontColorCollectionView.backgroundColor = .clear
        colorView.addSubview(fontColorCollectionView)
        fontColorCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func setupFontLabel() {
        functionalView.addSubview(fontLabel)
        fontLabel.snp.makeConstraints { make in
            make.top.equalTo(colorView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
    
    func setupFontView() {
        fontView.backgroundColor = .systemGray6
        functionalView.addSubview(fontView)
        fontView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(fontLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            
        }
    }
    
    func setupAboveView() {
        fontView.addSubview(aboveView)
        
        aboveView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            
        }
    }
    
    func setupBelowView() {
        fontView.addSubview(belowView)

        belowView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
    }
    
    func setupFontButtons() {
        fontButton1.setTitle("American", for: .normal)
        fontButton2.setTitle("Avenir", for: .normal)
        fontButton3.setTitle(fontTypes[2], for: .normal)
        fontButton1.titleLabel?.font = UIFont(name: fontTypes[0], size: 15)
        fontButton1.setTitleColor(.black, for: .normal)
        fontButton2.titleLabel?.font = UIFont(name: fontTypes[1], size: 15)
        fontButton2.setTitleColor(.black, for: .normal)
        fontButton3.titleLabel?.font = UIFont(name: fontTypes[2], size: 15)
        fontButton3.setTitleColor(.black, for: .normal)

        aboveView.addSubview(fontButton1)
        aboveView.addSubview(fontButton2)
        aboveView.addSubview(fontButton3)

        fontButton1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)
        }

        fontButton2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)

        }

        fontButton3.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)
        }
        
        fontButton1.layer.cornerRadius = view.frame.width / 30
        fontButton2.layer.cornerRadius = view.frame.width / 30
        fontButton3.layer.cornerRadius = view.frame.width / 30

        fontButton4.setTitle(fontTypes[3], for: .normal)
        fontButton5.setTitle(fontTypes[4], for: .normal)
        fontButton6.setTitle(fontTypes[5], for: .normal)
        fontButton4.titleLabel?.font = UIFont(name: fontTypes[3], size: 15)
        fontButton4.setTitleColor(.black, for: .normal)
        fontButton5.titleLabel?.font = UIFont(name: fontTypes[4], size: 12)
        fontButton5.setTitleColor(.black, for: .normal)
        fontButton6.titleLabel?.font = UIFont(name: fontTypes[5], size: 12)
        fontButton6.setTitleColor(.black, for: .normal)
        
        belowView.addSubview(fontButton4)
        belowView.addSubview(fontButton5)
        belowView.addSubview(fontButton6)
        
        fontButton4.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)
        }

        fontButton5.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)

        }

        fontButton6.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)
        }
        
        fontButton4.layer.cornerRadius = view.frame.width / 30
        fontButton5.layer.cornerRadius = view.frame.width / 30
        fontButton6.layer.cornerRadius = view.frame.width / 30
    }

}

extension TextViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fontColorCollectionView {
            return colors.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontColorCell", for: indexPath) as! FontColorCell
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
            selectedTextColor = colors[indexPath.row]
            textLabel.textColor = selectedTextColor
    }
    
}

extension TextViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        enteredText = updatedText
        textLabel.text = enteredText
        textView.isHidden = enteredText.isEmpty
        return true
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
}
