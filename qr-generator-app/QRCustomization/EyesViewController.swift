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
    
    let realm = try! Realm()
    
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
        
        qrImageView.image = generateQRCode(from: data)
        view.addSubview(qrImageView)
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
        
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
        
        functionalView.addSubview(controlView)
        controlView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
        }
        
        controlView.addSubview(discardButton)
        
        discardButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(50)
            make.top.bottom.equalToSuperview()
            
        }
        
        controlView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(50)
            make.top.bottom.equalToSuperview()
            
        }
        
        
        eyesCollectionView.dataSource = self
        eyesCollectionView.delegate = self
        functionalView.addSubview(eyesCollectionView)
        
        eyesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview().inset(30)
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        let colorData = realm.objects(QRCodeColor.self)
        if colorData.count != 0 {
            let color = colorData.first!
            doc.design.backgroundColor(UIColor(hexString: color.backgroundColor).cgColor)
            doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: color.foregroundColor).cgColor))
        }
        
        let dotsData = realm.objects(QRCodeDots.self)
        if dotsData.count != 0 {
            let dot = dotsData.first!
            switch dot.dots {
            case "square":
                doc.design.shape.onPixels = QRCode.PixelShape.Square()
            case "circle":
                doc.design.shape.onPixels = QRCode.PixelShape.Circle()
            case "curvePixel":
                doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel()
            case "squircle":
                doc.design.shape.onPixels = QRCode.PixelShape.Squircle()
            case "pointy":
                doc.design.shape.onPixels = QRCode.PixelShape.Pointy()
            default:
                print(-1)
            }
        }
        
        let eyesData = realm.objects(QRCodeEyes.self)
        if eyesData.count != 0 {
            let eye = eyesData.first!
            switch eye.eyes {
            case "eye_square":
                doc.design.shape.eye = QRCode.EyeShape.Square()
            case "eye_circle":
                doc.design.shape.eye = QRCode.EyeShape.Circle()
            case "eye_barsHorizontal":
                doc.design.shape.eye = QRCode.EyeShape.BarsHorizontal()
            case "eye_barsVertical":
                doc.design.shape.eye = QRCode.EyeShape.BarsVertical()
            case "eye_corneredPixels":
                doc.design.shape.eye = QRCode.EyeShape.CorneredPixels()
            case "eye_leaf":
                doc.design.shape.eye = QRCode.EyeShape.Leaf()
            case "eye_pixels":
                doc.design.shape.eye = QRCode.EyeShape.Pixels()
            case "eye_roundedouter":
                doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
            case "eye_roundedpointingin":
                doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()
            case "eye_roundedRect":
                doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
            case "eye_squircle":
                doc.design.shape.eye = QRCode.EyeShape.Squircle()
            default:
                print(-1)
            }
        }
        
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func changeQRPattern(_ pattern: QRCodeEyeShapeGenerator) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        let colorData = realm.objects(QRCodeColor.self)
        if colorData.count != 0 {
            let color = colorData.first!
            doc.design.backgroundColor(UIColor(hexString: color.backgroundColor).cgColor)
            doc.design.style.onPixels = QRCode.FillStyle.Solid((UIColor(hexString: color.foregroundColor).cgColor))
        }
        
        let dotsData = realm.objects(QRCodeDots.self)
        if dotsData.count != 0 {
            let dot = dotsData.first!
            switch dot.dots {
            case "square":
                doc.design.shape.onPixels = QRCode.PixelShape.Square()
            case "circle":
                doc.design.shape.onPixels = QRCode.PixelShape.Circle()
            case "curvePixel":
                doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel()
            case "squircle":
                doc.design.shape.onPixels = QRCode.PixelShape.Squircle()
            case "pointy":
                doc.design.shape.onPixels = QRCode.PixelShape.Pointy()
            default:
                print(-1)
            }
        }
        
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
            let qrWithEyes = QRCodeEyes()
            qrWithEyes.eyes = eyesSelected
            realm.beginWrite()
            realm.add(qrWithEyes)
            try! realm.commitWrite()
        } else {
            let eyes = eyesData.first!
            realm.beginWrite()
            eyes.eyes = eyesSelected
            try! realm.commitWrite()
        }
        delegate?.qrEyesChanged(eyesPattern: eyesSelected)
        dismiss(animated: true)
    }

}

extension EyesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eyesPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        cell.imageView.image = UIImage(named: eyesPatterns[indexPath.item])
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pattern: QRCodeEyeShapeGenerator = eyesClasses[indexPath.item]
        eyesSelected = eyesPatterns[indexPath.item]
        qrImageView.image = changeQRPattern(pattern)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
