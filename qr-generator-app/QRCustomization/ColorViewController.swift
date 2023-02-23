//
//  TextViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.

import UIKit
import SnapKit
import QRCode
import RealmSwift
import WMSegmentControl

/*
 3) Create a ColorPicker
 */

protocol ColorDelegate {
    func qrColorChanged(backgroundColor: String, foregroundColor: String)
}

class ColorViewController: UIViewController {
    
    var realmData = RealmData()
    
    var delegate: ColorDelegate?
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Color"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return titleLabel
    }()
    
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
        button.tintColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return button
    }()
    
    let anotherSegment = WMSegment()
    
    let freeLabel: UILabel = {
        let label = UILabel()
        label.text = "Free Colors"
        label.textColor = .white
        return label
    }()
    
    let freeView: UIView = {
        let view = UIView()
        return view
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
    
    let paidLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium Colors"
        label.textColor = .white
        return label
    }()
    
    let paidView: UIView = {
        let view = UIView()
        return view
    }()
    
    let pickerButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Set Custom Color"
        filled.buttonSize = .large
        filled.subtitle = "with color picker"
        filled.image = UIImage(systemName: "paintpalette.fill")
        filled.baseBackgroundColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        
        filled.imagePlacement = .trailing
        filled.imagePadding = 10
        
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.addTarget(self, action: #selector(showColorPicker), for: .touchUpInside)
        return button
    }()
    
    let picker = UIColorPickerViewController()
    
    let colors: [UIColor] = [
        UIColor.systemRed,
        UIColor.systemGreen,
        UIColor.systemBlue,
        UIColor.systemOrange,
        UIColor.systemYellow,
        UIColor.systemPink,
        UIColor.systemPurple,
        UIColor.systemTeal,
        UIColor.systemIndigo,
        UIColor.systemGray,
        UIColor.black,
        UIColor.white
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        navigationItem.titleView = titleLabel
        setupUI()
    }
    
    func setupUI() {
        setGradient()
        //        setGradientsArray()
        setupQRImageView()
        setupTextView()
        setupTextLabel()
        setupFunctionalView()
        setupControlView()
        setupDiscardButton()
        setupConfirmButton()
        setupColorSelectionSegmentedControl()
        setupFreeLabel()
        setupFreeView()
        setupColorsCollectionView()
        setupPaidLabel()
        setupPickerButton()
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
    
    @objc func showColorPicker() {
        let purchase = KSPurchase()
        if !purchase.hasPremium() {
            let alert = purchase.showAlertToGetPremium()
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let picker = UIColorPickerViewController()
            picker.delegate = self
            picker.modalPresentationStyle = .custom
            picker.transitioningDelegate = self
            self.present(picker, animated: true, completion: nil)
        }
        
        
        
    }
    
}



