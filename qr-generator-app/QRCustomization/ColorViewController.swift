//
//  TextViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.

import UIKit
import SnapKit
import QRCode
import RealmSwift

protocol ColorDelegate {
    func qrColorChanged(backgroundColor: String, foregroundColor: String)
}

class ColorViewController: UIViewController {
    
    let realm = try! Realm()
    
    var delegate: ColorDelegate?
    
    let qrImageView = UIImageView()
    var data = ""
    var foregroundColor: UIColor = .black
    var backgroundColor: UIColor = .white
    
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
    
    
    let colorSelectionSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Foreground", "Background"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    
    let colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let colors: [UIColor] = [
        .red, .green, .blue, .yellow, .purple, .orange,
        .cyan, .magenta, .brown, .black, .darkGray, .lightGray,
        .gray, .systemRed, .systemGreen, .systemBlue,
        .systemYellow, .systemPurple, .systemOrange, .systemPink,
        .systemTeal, .systemIndigo, .systemGray, .systemPink,
        .systemRed, .systemGreen, .systemBlue, .systemYellow,
        .systemPurple, .systemOrange
    ]
    
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
        
        controlView.addSubview(colorSelectionSegmentedControl)
        colorSelectionSegmentedControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        functionalView.addSubview(colorsCollectionView)
        
        colorsCollectionView.snp.makeConstraints { make in
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
    
    func changeQRColor(_ backgroundColor: UIColor, _ foregroundColor: UIColor) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.backgroundColor(backgroundColor.cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid(foregroundColor.cgColor)
        
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
        
        
        let changed = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: changed!)
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        print(backgroundColor.hexString, foregroundColor.hexString)
        let colorData = realm.objects(QRCodeColor.self)
        if colorData.count == 0 {
            let coloredQRCode = QRCodeColor()
            coloredQRCode.backgroundColor = backgroundColor.hexString
            coloredQRCode.foregroundColor = foregroundColor.hexString
            realm.beginWrite()
            realm.add(coloredQRCode)
            try! realm.commitWrite()
        } else {
            let color = colorData.first!
            realm.beginWrite()
            color.backgroundColor = backgroundColor.hexString
            color.foregroundColor = foregroundColor.hexString
            try! realm.commitWrite()
        }
        delegate?.qrColorChanged(backgroundColor: backgroundColor.hexString, foregroundColor: foregroundColor.hexString)
        dismiss(animated: true)
    }
}

extension ColorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.backgroundColor = colors[indexPath.item]
        cell.color = colors[indexPath.item]
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.row]
        switch (colorSelectionSegmentedControl.selectedSegmentIndex)  {
        case 0:
            foregroundColor = selectedColor
        case 1:
            backgroundColor = selectedColor
        default:
            backgroundColor = UIColor.white
            foregroundColor = UIColor.black
        }
        qrImageView.image = changeQRColor(backgroundColor, foregroundColor)
    }
}


