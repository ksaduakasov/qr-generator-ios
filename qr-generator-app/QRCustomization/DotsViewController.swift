//
//  DotsViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode
import RealmSwift

//enum Dots {
//    case square
//    case circle
//    case curvePixel
//    case roundedRect
//    case horizontal
//    case vertical
//    case roundedPath
//    case squircle
//    case pointy
//}

protocol DotsDelegate {
    func qrDotsChanged(dotsPattern: String)
}

class DotsViewController: UIViewController {
    
    var realmData = RealmData()
    
    var delegate: DotsDelegate?
    
    let qrImageView: UIImageView = UIImageView()
    var data = ""
    
    let textView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let textLabel = UILabel()
    
    var dotsSelected: String = String()
    
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
    
    
    let pointsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DotsCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let pointPatterns: [String] = ["square","circle","curvePixel","squircle","pointy"]
    let pointClasses: [QRCodePixelShapeGenerator] = [QRCode.PixelShape.Square(), QRCode.PixelShape.Circle(), QRCode.PixelShape.CurvePixel(), QRCode.PixelShape.Squircle(), QRCode.PixelShape.Pointy()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupUI()
    }
    
    func setupUI() {
        setupQRImageView()
        setupTextView()
        setupTextLabel()
        setupFunctionalView()
        setupControlView()
        setupDiscardButton()
        setupConfirmButton()
        setupPointsCollectionView()
        
        setupDotsFromRealm()
    }
    
    func setupDotsFromRealm() {
        let dotsData = realmData.realm.objects(QRCodeDots.self)
        if dotsData.count != 0 {
            let dots = dotsData.first!
            self.dotsSelected = dots.dots
        } else {
            self.dotsSelected = ""
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
    
    func changeQRPattern(_ pattern: QRCodePixelShapeGenerator) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        doc.design.shape.onPixels = pattern
        realmData.getEyes(doc)
        realmData.getLogo(doc)
        realmData.getText(self.textView, self.textLabel)

        let changed = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: changed!)
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        let dotsData = realmData.realm.objects(QRCodeDots.self)
        if dotsData.count == 0 {
            realmData.addDots(dotsSelected)
        } else {
            let dots = dotsData.first!
            realmData.updateDots(dots, dotsSelected)
        }
        delegate?.qrDotsChanged(dotsPattern: dotsSelected)
        dismiss(animated: true)
    }
    
    
}
