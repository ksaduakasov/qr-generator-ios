//
//  TextViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.

import UIKit
import SnapKit
import QRCode
import RealmSwift

/*
 
 1) Set FunctionalView background color to gray
 2) Create custom segmentedControl
 3) Create a ColorPicker
 */

protocol ColorDelegate {
    func qrColorChanged(backgroundColor: String, foregroundColor: String)
}

class ColorViewController: UIViewController {

    var realmData = RealmData()
    
    var delegate: ColorDelegate?
    
    let qrImageView = UIImageView()
    var data = ""
    
    let textView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let textLabel = UILabel()
    
    var foregroundColor = UIColor()
    var backgroundColor = UIColor()
    
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
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
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
        setupColorSelectionSegmentedControl()
        setupcolorsCollectionView()
        
        setupColorsFromRealm()
    }
    
    func setupColorsFromRealm() {
        let colorData = realmData.realm.objects(QRCodeColor.self)
        if colorData.count != 0 {
            let color = colorData.first!
            self.backgroundColor = UIColor(hexString: color.backgroundColor)
            self.foregroundColor = UIColor(hexString: color.foregroundColor)
        } else {
            self.backgroundColor = UIColor.white
            self.foregroundColor = UIColor.black
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        realmData.getLogo(doc)
        realmData.getText(textView, textLabel)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func changeQRColor(_ backgroundColor: UIColor, _ foregroundColor: UIColor) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.backgroundColor(backgroundColor.cgColor)
        doc.design.style.onPixels = QRCode.FillStyle.Solid(foregroundColor.cgColor)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        realmData.getLogo(doc)
        realmData.getText(textView, textLabel)
        let changed = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: changed!)
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        let colorData = realmData.realm.objects(QRCodeColor.self)
        if colorData.count == 0 {
            realmData.addColor(backgroundColor, foregroundColor)
        } else {
            let color = colorData.first!
            realmData.updateColor(color, backgroundColor, foregroundColor)
        }
        delegate?.qrColorChanged(backgroundColor: backgroundColor.hexString, foregroundColor: foregroundColor.hexString)
        dismiss(animated: true)
    }
}


