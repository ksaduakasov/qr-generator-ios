//
//  LogoViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode
import RealmSwift

protocol LogoDelegate {
    func qrLogoChanged(logo: Data?)
}

class LogoViewController: UIViewController {
    
    var realmData = RealmData()
    
    var delegate: LogoDelegate?
    
    let qrImageView = UIImageView()
    var data = ""
    var selectedLogo: UIImage?
    
    let functionalView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let controlView: UIView = {
        let view = UIView()
        return view
    }()
    
    let discardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return button
    }()
    
    
    let logoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyesCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let logoTemplates: [String] = ["eye_square","eye_circle", "eye_barsHorizontal", "eye_barsVertical", "eye_corneredPixels", "eye_leaf", "eye_pixels", "eye_roundedouter", "eye_roundedpointingin", "eye_roundedRect", "eye_squircle", "square","circle","curvePixel","roundedRect","horizontal","vertical","roundedPath","squircle","pointy", "eye_colorstyles"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupUI()
    }
    
    func setupUI() {
        setupQRImageView()
        setupFunctionalView()
        setupControlView()
        setupDiscardButton()
        setupConfirmButton()
        setupLogoCollectionView()
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        realmData.getLogo(doc)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func QRWithLogo(_ imageName: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        if imageName.isEmpty {
            doc.logoTemplate = nil
        } else {
            doc.logoTemplate = QRCode.LogoTemplate.SquareCenter(
                image: (UIImage(named: imageName)?.cgImage)!,
                inset: 8)
        }
        let qrCodeWithLogo = doc.uiImage(dimension: 300)
        return qrCodeWithLogo
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        guard let logo = selectedLogo else {
            let logoData = realm.objects(QRCodeLogo.self)
            if logoData.count == 0 {
                realmData.addLogo(nil)
            } else {
                let logo = logoData.first!
                realmData.updateLogo(logo, nil)
            }
            delegate?.qrLogoChanged(logo: nil)
            dismiss(animated: true)
            return
        }
        let imageData = logo.jpegData(compressionQuality: 1.0)
        
        let logoData = realm.objects(QRCodeLogo.self)
        if logoData.count == 0 {
            realmData.addLogo(imageData ?? nil)
        } else {
            let logo = logoData.first!
            realmData.updateLogo(logo, imageData)
        }
        delegate?.qrLogoChanged(logo: imageData)
        dismiss(animated: true)
    }
    
}
