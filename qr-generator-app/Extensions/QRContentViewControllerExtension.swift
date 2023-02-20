//
//  QRContentViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 20.02.2023.
//

import Foundation
import UIKit

extension QRContentViewController {
    func setupNavigationItems() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        let createButton = UIBarButtonItem(title: "CREATE", style: .plain, target: self, action: #selector(createButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = createButton
        navigationItem.titleView = titleLabel
    }
    
    func setupTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            make.height.equalToSuperview().dividedBy(2.5)
        }
    }
    
    func setupTextLabel() {
        textView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
    }
    
    func setupTextField() {
        textField.inputAccessoryView = toolbar
        textView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(5)
        }
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            make.height.equalToSuperview().dividedBy(3.5)
        }
    }
}

extension QRContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionsCell", for: indexPath) as! OptionsCell
        let item = data[indexPath.item]
        cell.imageLogo.image = UIImage(named: item.image)
        cell.title.text = item.title
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 5
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowColor = UIColor.black.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! OptionsCell
        selectedCell.isActive = true
        textLabel.text = selectedCell.title.text
        textField.isHidden = false
        if textLabel.text == "Phone" {
            textField.keyboardType = .numberPad
        } else {
            textField.keyboardType = .default
        }
        textField.placeholder = "Please fill in the \(selectedCell.title.text!.lowercased())"
        QRContentViewController.contentType = selectedCell.title.text!
        print(selectedCell.isActive)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! OptionsCell
        selectedCell.isActive = false
        print(selectedCell.isActive)
    }
    
    
    
}

extension QRContentViewController {
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1).cgColor
        let end = UIColor(red: 244/255, green: 245/255, blue: 248/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        view.layer.addSublayer(gradientLayer)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

