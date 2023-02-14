//
//  EyesViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode
import RealmSwift

protocol EyesDelegate {
    func qrEyesChanged(eyesPattern: String)
}

class EyesViewController: UIViewController {
    
    var realmData = RealmData()
    
    var delegate: EyesDelegate?
    
    let qrImageView = UIImageView()
    var data = ""
    
    var eyesSelected: String = ""
    
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
    
    
    let eyesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyesCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let eyesPatterns: [String] = ["eye_square","eye_circle", "eye_barsHorizontal", "eye_barsVertical", "eye_corneredPixels", "eye_leaf", "eye_pixels", "eye_roundedouter", "eye_roundedpointingin", "eye_roundedRect", "eye_squircle"]
    
    let eyesClasses: [QRCodeEyeShapeGenerator] = [QRCode.EyeShape.Square(), QRCode.EyeShape.Circle(), QRCode.EyeShape.BarsHorizontal(), QRCode.EyeShape.BarsVertical(), QRCode.EyeShape.CorneredPixels(), QRCode.EyeShape.Leaf(), QRCode.EyeShape.Pixels(), QRCode.EyeShape.RoundedOuter(), QRCode.EyeShape.RoundedPointingIn(), QRCode.EyeShape.RoundedRect(), QRCode.EyeShape.Squircle()]
    
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
        setupEyesCollectionView()
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func changeQRPattern(_ pattern: QRCodeEyeShapeGenerator) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        doc.design.shape.eye = pattern
        let changed = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: changed!)
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        let eyesData = realm.objects(QRCodeEyes.self)
        if eyesData.count == 0 {
            realmData.addEyes(eyesSelected)
        } else {
            let eyes = eyesData.first!
            realmData.updateEyes(eyes, eyesSelected)
        }
        delegate?.qrEyesChanged(eyesPattern: eyesSelected)
        dismiss(animated: true)
    }
    
}

