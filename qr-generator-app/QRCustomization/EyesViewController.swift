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
    
    let textView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let textLabel = UILabel()
    
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
    
    let freeLabel: UILabel = {
        let label = UILabel()
        label.text = "Free Icons"
        return label
    }()
    
    let freeView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    let freeEyesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyesCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let paidLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium Icons"
        return label
    }()
    
    let paidView: UIView = {
        let view = UIView()
        return view
    }()
    
    let paidEyesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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
        setGradient()
        setupQRImageView()
        setupTextView()
        setupTextLabel()
        setupFunctionalView()
        setupControlView()
        setupDiscardButton()
        setupConfirmButton()
        setupFreeLabel()
        setupFreeView()
        setupFreeEyesCollectionView()
        setupPaidLabel()
        setupPaidView()
        setupPaidEyesCollectionView()
        setupEyesFromRealm()
    }
    
    func setupEyesFromRealm() {
        let eyesData = realmData.realm.objects(QRCodeEyes.self)
        if eyesData.count != 0 {
            let eyes = eyesData.first!
            self.eyesSelected = eyes.eyes
        } else {
            self.eyesSelected = ""
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        realmData.getLogo(doc)
        realmData.getText(self.textView, self.textLabel)

        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func changeQRPattern(_ pattern: QRCodeEyeShapeGenerator) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getLogo(doc)
        realmData.getText(self.textView, self.textLabel)

        doc.design.shape.eye = pattern
        let changed = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: changed!)
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        let eyesData = realmData.realm.objects(QRCodeEyes.self)
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

