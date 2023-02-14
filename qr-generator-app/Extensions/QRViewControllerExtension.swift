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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
    }
    
    func setupGreenView() {
        greenView.backgroundColor = .green
        greenView.layer.cornerRadius = 20
        view.addSubview(greenView)
        
        greenView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(100)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setupButtonStructure() {
        for i in 0..<buttonTitles.count {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitles[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.layer.cornerRadius = 20
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            
            greenView.addSubview(button)
            buttons.append(button)
        }
    }
    
    func setupButtonConstraints() {
        for i in 0..<buttons.count {
            buttons[i].snp.makeConstraints { make in
                make.width.equalToSuperview().dividedBy(4)
                make.height.equalTo(80)
                
                if i < 3 {
                    make.top.equalToSuperview().offset(80)
                } else {
                    make.bottom.equalToSuperview().offset(-80)
                }
                
                if i % 3 == 0 {
                    make.left.equalToSuperview().offset(20)
                } else if i % 3 == 1 {
                    make.centerX.equalToSuperview()
                } else {
                    make.right.equalToSuperview().offset(-20)
                }
            }
            buttons[i].addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
        present(logoVC, animated: true)
    }
    
    func openTextViewController() {
        let textVC = TextViewController()
        textVC.modalPresentationStyle = .fullScreen
        textVC.data = data
        present(textVC, animated: true)
    }
}


//MARK: -implement reverse order bug
extension QRViewController: ColorDelegate {
    func qrColorChanged(backgroundColor: String, foregroundColor: String) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.backgroundColor(UIColor(hexString: backgroundColor).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor).cgColor))
        
        doc.design.shape.onPixels = self.dots ?? QRCode.PixelShape.Square()
        doc.design.shape.eye = self.eyes ?? QRCode.EyeShape.Square()
        
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
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
            print(-1)
        }
        doc.design.backgroundColor(UIColor(hexString: backgroundColor ?? UIColor.white.hexString).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor ?? UIColor.black.hexString).cgColor))
        doc.design.shape.eye = self.eyes ?? QRCode.EyeShape.Square()
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
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
            print(-1)
        }
        
        doc.design.backgroundColor(UIColor(hexString: backgroundColor ?? UIColor.white.hexString).cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: foregroundColor ?? UIColor.black.hexString).cgColor))
        doc.design.shape.onPixels = self.dots ?? QRCode.PixelShape.Square()
        
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        qrImageView.image = UIImage(cgImage: generated!)
    }
}