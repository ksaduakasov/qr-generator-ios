//
//  QRViewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit
import QRCode

extension QRViewController {
    func setNavigationItems() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        let saveButton = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.titleView = editLabel
    }
    
    func setupImageView() {
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
    
    func setupButtonsView() {
        buttonsView.backgroundColor = .white
        buttonsView.layer.cornerRadius = 20
        view.addSubview(buttonsView)
        
        buttonsView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(view.bounds.height / 10)
            make.bottom.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
    }
    
    func setupButtonInnerView() {
        
        buttonsView.addSubview(buttonInnerView)
        buttonInnerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        
        buttonInnerView.addSubview(aboveView)
        aboveView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }

        
        buttonInnerView.addSubview(belowView)
        belowView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }

        
        buttonInnerView.addSubview(middleView)
        middleView.snp.makeConstraints { make in
            make.top.equalTo(aboveView.snp.bottom)
            make.bottom.equalTo(belowView.snp.top)
            make.left.right.equalToSuperview()
        }

    }
    
    func setupColorButton() {
        colorButton.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        colorButton.layer.cornerRadius = view.bounds.width / 20
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openColorVC))
        colorButton.addGestureRecognizer(tapGesture)
        colorButton.isUserInteractionEnabled = true
        aboveView.addSubview(colorButton)
        
        colorButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-110)
            make.height.equalTo(colorButton.snp.width)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        
        colorButton.addSubview(colorImageView)
        colorImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        aboveView.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(colorButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(-110)
        }
    }
    
    func setupDotsButton() {
        dotsButton.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        dotsButton.layer.cornerRadius = view.bounds.width / 20
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDotsVC))
        dotsButton.addGestureRecognizer(tapGesture)
        dotsButton.isUserInteractionEnabled = true
        aboveView.addSubview(dotsButton)
        
        dotsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(110)
            make.height.equalTo(dotsButton.snp.width)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        
        dotsButton.addSubview(dotsImageView)
        dotsImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        aboveView.addSubview(dotsLabel)
        dotsLabel.snp.makeConstraints { make in
            make.top.equalTo(dotsButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(110)
        }
    }
    
    func setupEyesButton() {
        eyesButton.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        eyesButton.layer.cornerRadius = view.bounds.width / 20
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openEyesVC))
        eyesButton.addGestureRecognizer(tapGesture)
        eyesButton.isUserInteractionEnabled = true
        middleView.addSubview(eyesButton)
        
        eyesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(eyesButton.snp.width)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        
        eyesButton.addSubview(eyesImageView)
        eyesImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        middleView.addSubview(eyesLabel)
        eyesLabel.snp.makeConstraints { make in
            make.top.equalTo(eyesButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupLogoButton() {
        logoButton.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        logoButton.layer.cornerRadius = view.bounds.width / 20
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLogoVC))
        logoButton.addGestureRecognizer(tapGesture)
        logoButton.isUserInteractionEnabled = true
        belowView.addSubview(logoButton)
        
        logoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-110)
            make.height.equalTo(logoButton.snp.width)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        
        logoButton.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        belowView.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(logoButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(-110)
        }
    }
    
    func setupTextButton() {
        textButton.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        textButton.layer.cornerRadius = view.bounds.width / 20
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openTextVC))
        textButton.addGestureRecognizer(tapGesture)
        textButton.isUserInteractionEnabled = true
        belowView.addSubview(textButton)
        
        textButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(110)
            make.height.equalTo(textButton.snp.width)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        
        textButton.addSubview(textImageView)
        textImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        belowView.addSubview(textBtnLabel)
        textBtnLabel.snp.makeConstraints { make in
            make.top.equalTo(textButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(110)
        }
    }
    
    
    
    func openTemplateViewController() {
        let templateVC = TemplateViewController()
        navigationController?.pushViewController(templateVC, animated: true)
    }
    
    func openColorViewController() {
        let colorVC = ColorViewController()
        colorVC.modalPresentationStyle = .fullScreen
        colorVC.data = data
        colorVC.delegate = self
        present(colorVC, animated: true)
    }
    
    func openDotsViewController() {
        let dotsVC = DotsViewController()
        dotsVC.modalPresentationStyle = .fullScreen
        dotsVC.data = data
        dotsVC.delegate = self
        present(dotsVC, animated: true)
    }
    
    func openEyesViewController() {
        let eyesVC = EyesViewController()
        eyesVC.modalPresentationStyle = .fullScreen
        eyesVC.data = data
        eyesVC.delegate = self
        present(eyesVC, animated: true)
    }
    
    func openLogoViewController() {
        let logoVC = LogoViewController()
        logoVC.modalPresentationStyle = .fullScreen
        logoVC.data = data
        logoVC.delegate = self
        present(logoVC, animated: true)
    }
    
    func openTextViewController() {
        let textVC = TextViewController()
        textVC.modalPresentationStyle = .fullScreen
        textVC.data = data
        textVC.delegate = self
        present(textVC, animated: true)
    }
}


extension QRViewController: ColorDelegate {
    func qrColorChanged(backgroundColor: String, foregroundColor: String) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.backgroundColor(UIColor(hexString: backgroundColor).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor).cgColor))
        
        doc.design.shape.onPixels = self.dots ?? QRCode.PixelShape.Square()
        doc.design.shape.eye = self.eyes ?? QRCode.EyeShape.Square()
        doc.logoTemplate = self.logo != nil ? QRCode.LogoTemplate.SquareCenter(
            image: (UIImage(data: self.logo!)?.cgImage)!,
            inset: 8) : nil
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
        
        let textData = realmData.realm.objects(QRCodeText.self)
        if textData.count != 0 {
            let text = textData.first!
            
            self.textContent = text.textContent
            self.textColor = text.textColor
            self.textFont = text.textFont
            if !self.textContent.isEmpty {
                self.textView.isHidden = false
                self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                self.textLabel.text = self.textContent
                self.textLabel.textColor = UIColor(hexString: self.textColor)
                self.textLabel.font = UIFont(name: self.textFont, size: 20)
            } else {
                self.textView.isHidden = true
            }
        } else {
            self.textView.isHidden = true
        }
    }
}

extension QRViewController: DotsDelegate {
    func qrDotsChanged(dotsPattern: String) {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        switch dotsPattern {
        case "square":
            self.dots = QRCode.PixelShape.Square()
            doc.design.shape.onPixels = self.dots!
        case "circle":
            self.dots = QRCode.PixelShape.Circle()
            doc.design.shape.onPixels = self.dots!
        case "curvePixel":
            self.dots = QRCode.PixelShape.CurvePixel()
            doc.design.shape.onPixels = self.dots!
        case "squircle":
            self.dots = QRCode.PixelShape.Squircle()
            doc.design.shape.onPixels = self.dots!
        case "pointy":
            self.dots = QRCode.PixelShape.Pointy()
            doc.design.shape.onPixels = self.dots!
        default:
            print("hello from qrDotsChanged function")
        }
        doc.design.backgroundColor(UIColor(hexString: backgroundColor ?? UIColor.white.hexString).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor ?? UIColor.black.hexString).cgColor))
        doc.design.shape.eye = self.eyes ?? QRCode.EyeShape.Square()
        guard let logo = self.logo else {
            doc.logoTemplate = nil
            let generated = doc.cgImage(CGSize(width: 800, height: 800))
            qrImageView.image = UIImage(cgImage: generated!)
            
            let textData = realmData.realm.objects(QRCodeText.self)
            if textData.count != 0 {
                let text = textData.first!
                
                self.textContent = text.textContent
                self.textColor = text.textColor
                self.textFont = text.textFont
                if !self.textContent.isEmpty {
                    self.textView.isHidden = false
                    self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                    self.textLabel.text = self.textContent
                    self.textLabel.textColor = UIColor(hexString: self.textColor)
                    self.textLabel.font = UIFont(name: self.textFont, size: 20)
                } else {
                    self.textView.isHidden = true
                }
            } else {
                self.textView.isHidden = true
            }
            return
        }
        doc.logoTemplate = QRCode.LogoTemplate.SquareCenter(
            image: (UIImage(data: self.logo!)?.cgImage)!,
            inset: 8)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
        
        let textData = realmData.realm.objects(QRCodeText.self)
        if textData.count != 0 {
            let text = textData.first!
            
            self.textContent = text.textContent
            self.textColor = text.textColor
            self.textFont = text.textFont
            if !self.textContent.isEmpty {
                self.textView.isHidden = false
                self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                self.textLabel.text = self.textContent
                self.textLabel.textColor = UIColor(hexString: self.textColor)
                self.textLabel.font = UIFont(name: self.textFont, size: 20)
            } else {
                self.textView.isHidden = true
            }
        } else {
            self.textView.isHidden = true
        }
    }
}

extension QRViewController: EyesDelegate {
    func qrEyesChanged(eyesPattern: String) {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        switch eyesPattern {
        case "eye_square":
            self.eyes = QRCode.EyeShape.Square()
            doc.design.shape.eye = self.eyes!
        case "eye_circle":
            self.eyes = QRCode.EyeShape.Circle()
            doc.design.shape.eye = self.eyes!
        case "eye_barsHorizontal":
            self.eyes = QRCode.EyeShape.BarsHorizontal()
            doc.design.shape.eye = self.eyes!
        case "eye_barsVertical":
            self.eyes = QRCode.EyeShape.BarsVertical()
            doc.design.shape.eye = self.eyes!
        case "eye_corneredPixels":
            self.eyes = QRCode.EyeShape.CorneredPixels()
            doc.design.shape.eye = self.eyes!
        case "eye_leaf":
            self.eyes = QRCode.EyeShape.Leaf()
            doc.design.shape.eye = self.eyes!
        case "eye_pixels":
            self.eyes = QRCode.EyeShape.Pixels()
            doc.design.shape.eye = self.eyes!
        case "eye_roundedouter":
            self.eyes = QRCode.EyeShape.RoundedOuter()
            doc.design.shape.eye = self.eyes!
        case "eye_roundedpointingin":
            self.eyes = QRCode.EyeShape.RoundedPointingIn()
            doc.design.shape.eye = self.eyes!
        case "eye_roundedRect":
            self.eyes = QRCode.EyeShape.RoundedRect()
            doc.design.shape.eye = self.eyes!
        case "eye_squircle":
            self.eyes = QRCode.EyeShape.Squircle()
            doc.design.shape.eye = self.eyes!
        default:
            print("hello from qrEyesChanged function")
        }
        
        doc.design.backgroundColor(UIColor(hexString: backgroundColor ?? UIColor.white.hexString).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor ?? UIColor.black.hexString).cgColor))
        doc.design.shape.onPixels = self.dots ?? QRCode.PixelShape.Square()
        guard let logo = self.logo else {
            doc.logoTemplate = nil
            let generated = doc.cgImage(CGSize(width: 800, height: 800))
            qrImageView.image = UIImage(cgImage: generated!)
            
            let textData = realmData.realm.objects(QRCodeText.self)
            if textData.count != 0 {
                let text = textData.first!
                
                self.textContent = text.textContent
                self.textColor = text.textColor
                self.textFont = text.textFont
                if !self.textContent.isEmpty {
                    self.textView.isHidden = false
                    self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                    self.textLabel.text = self.textContent
                    self.textLabel.textColor = UIColor(hexString: self.textColor)
                    self.textLabel.font = UIFont(name: self.textFont, size: 20)
                } else {
                    self.textView.isHidden = true
                }
            } else {
                self.textView.isHidden = true
            }
            return
        }
        doc.logoTemplate = QRCode.LogoTemplate.SquareCenter(
            image: (UIImage(data: self.logo!)?.cgImage)!,
            inset: 8)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
        
        let textData = realmData.realm.objects(QRCodeText.self)
        if textData.count != 0 {
            let text = textData.first!
            
            self.textContent = text.textContent
            self.textColor = text.textColor
            self.textFont = text.textFont
            if !self.textContent.isEmpty {
                self.textView.isHidden = false
                self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                self.textLabel.text = self.textContent
                self.textLabel.textColor = UIColor(hexString: self.textColor)
                self.textLabel.font = UIFont(name: self.textFont, size: 20)
            } else {
                self.textView.isHidden = true
            }
        } else {
            self.textView.isHidden = true
        }
    }
    
}

extension QRViewController: LogoDelegate {
    func qrLogoChanged(logo: Data?) {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.backgroundColor(UIColor(hexString: backgroundColor ?? UIColor.white.hexString).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor ?? UIColor.black.hexString).cgColor))
        doc.design.shape.onPixels = self.dots ?? QRCode.PixelShape.Square()
        doc.design.shape.eye = self.eyes ?? QRCode.EyeShape.Square()
        guard let logo = logo else {
            self.logo = nil
            doc.logoTemplate = nil
            let generated = doc.cgImage(CGSize(width: 800, height: 800))
            qrImageView.image = UIImage(cgImage: generated!)
            
            let textData = realmData.realm.objects(QRCodeText.self)
            if textData.count != 0 {
                let text = textData.first!
                
                self.textContent = text.textContent
                self.textColor = text.textColor
                self.textFont = text.textFont
                if !self.textContent.isEmpty {
                    self.textView.isHidden = false
                    self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                    self.textLabel.text = self.textContent
                    self.textLabel.textColor = UIColor(hexString: self.textColor)
                    self.textLabel.font = UIFont(name: self.textFont, size: 20)
                } else {
                    self.textView.isHidden = true
                }
            } else {
                self.textView.isHidden = true
            }
            return
        }
        self.logo = logo
        doc.logoTemplate = QRCode.LogoTemplate.SquareCenter(
            image: (UIImage(data: self.logo!)?.cgImage)!,
            inset: 8)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
        
        let textData = realmData.realm.objects(QRCodeText.self)
        if textData.count != 0 {
            let text = textData.first!
            
            self.textContent = text.textContent
            self.textColor = text.textColor
            self.textFont = text.textFont
            if !self.textContent.isEmpty {
                self.textView.isHidden = false
                self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                self.textLabel.text = self.textContent
                self.textLabel.textColor = UIColor(hexString: self.textColor)
                self.textLabel.font = UIFont(name: self.textFont, size: 20)
            } else {
                self.textView.isHidden = true
            }
        } else {
            self.textView.isHidden = true
        }
    }
    
}

extension QRViewController: TextDelegate {
    func qrTextChanged(textContent: String, textColor: String, textFont: String) {
        
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.backgroundColor(UIColor(hexString: backgroundColor ?? UIColor.white.hexString).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor ?? UIColor.black.hexString).cgColor))
        doc.design.shape.onPixels = self.dots ?? QRCode.PixelShape.Square()
        doc.design.shape.eye = self.eyes ?? QRCode.EyeShape.Square()
        guard let logo = logo else {
            self.logo = nil
            doc.logoTemplate = nil
            let generated = doc.cgImage(CGSize(width: 800, height: 800))
            qrImageView.image = UIImage(cgImage: generated!)
            
            let textData = realmData.realm.objects(QRCodeText.self)
            if textData.count != 0 {
                let text = textData.first!
                
                self.textContent = text.textContent
                self.textColor = text.textColor
                self.textFont = text.textFont
                if !self.textContent.isEmpty {
                    self.textView.isHidden = false
                    self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                    self.textLabel.text = self.textContent
                    self.textLabel.textColor = UIColor(hexString: self.textColor)
                    self.textLabel.font = UIFont(name: self.textFont, size: 20)
                } else {
                    self.textView.isHidden = true
                }
            } else {
                self.textView.isHidden = true
            }
            return
        }
        self.logo = logo
        doc.logoTemplate = QRCode.LogoTemplate.SquareCenter(
            image: (UIImage(data: self.logo!)?.cgImage)!,
            inset: 8)
        
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
        
        
        let textData = realmData.realm.objects(QRCodeText.self)
        if textData.count != 0 {
            let text = textData.first!
            
            self.textContent = text.textContent
            self.textColor = text.textColor
            self.textFont = text.textFont
            if !self.textContent.isEmpty {
                self.textView.isHidden = false
                self.textView.backgroundColor = UIColor(hexString: backgroundColor ?? UIColor.white.hexString)
                self.textLabel.text = self.textContent
                self.textLabel.textColor = UIColor(hexString: self.textColor)
                self.textLabel.font = UIFont(name: self.textFont, size: 20)
            } else {
                self.textView.isHidden = true
            }
        } else {
            self.textView.isHidden = true
        }
    }
    
    
}
