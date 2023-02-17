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
            make.height.equalTo(20)
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
        buttonInnerView.backgroundColor = .white
        buttonsView.addSubview(buttonInnerView)
        buttonInnerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(buttonsView.snp.height).dividedBy(1.2)
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
        aboveView.addSubview(colorButton)
        
        colorButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-110)
            make.bottom.equalToSuperview()
            make.width.equalTo(eyesButton.snp.width)
            make.height.equalTo(eyesButton.snp.width)
        }
        
        
    }
    
    func setupDotsButton() {
        aboveView.addSubview(dotsButton)
        
        dotsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(110)
            make.bottom.equalToSuperview()
            make.width.equalTo(eyesButton.snp.width)
            make.height.equalTo(eyesButton.snp.width)
        }
        
    
    }
    
    func setupEyesButton() {
        middleView.addSubview(eyesButton)
        
        eyesButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(eyesButton.snp.width)
            make.width.equalToSuperview().dividedBy(5)
        }
        
    
    }
    
    func setupTextButton() {
        belowView.addSubview(textButton)
        
        textButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(110)
            make.height.equalTo(eyesButton.snp.width)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        
    
    }
    
    
    func setupLogoButton() {
        belowView.addSubview(logoButton)

        logoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-110)
            make.height.equalTo(eyesButton.snp.width)
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
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
