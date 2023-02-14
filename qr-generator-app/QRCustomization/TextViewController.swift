//
//  TextViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.

import UIKit
import SnapKit
import QRCode
import RealmSwift

class TextViewController: UIViewController {
    
    let realm = try! Realm()
    
    let qrImageView = UIImageView()
    var data = ""
    
    var textColor = UIColor()
    var textFont = UIFont()
    
    let textView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "hello"
        return label
    }()
    
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
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.textAlignment = .center
        let placeholderString = NSAttributedString(string: "Please fill in the text here", attributes: [.foregroundColor: UIColor.lightGray])
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedPlaceholder = NSMutableAttributedString(attributedString: placeholderString)
        attributedPlaceholder.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: placeholderString.length))
        textField.attributedPlaceholder = attributedPlaceholder


        return textField
    }()
    
    let colorView: UIView = {
        let view = UIView()
//        view.backgroundColor = .green
        return view
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Solid color"
        return label
    }()
    
    let fontColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FontColorCell.self, forCellWithReuseIdentifier: "FontColorCell")
        cv.showsHorizontalScrollIndicator = false
//        cv.backgroundColor = .yellow
        return cv
    }()
    
    let fontView: UIView = {
        let view = UIView()
//        view.backgroundColor = .yellow
        return view
    }()
    
    let fontLabel: UILabel = {
        let label = UILabel()
        label.text = "Font"
        return label
    }()
    
    let fontCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FontCell.self, forCellWithReuseIdentifier: "FontCell")
//        cv.backgroundColor = .green
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
    
    let fontTypes = ["Arial", "Helvetica", "Verdana", "Times New Roman", "Courier", "Trebuchet MS", "Avenir", "Georgia", "Baskerville", "Gill Sans"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        textField.delegate = self

        qrImageView.image = generateQRCode(from: data)
        view.addSubview(qrImageView)
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
        
        let colorData = realm.objects(QRCodeColor.self)
        if colorData.count != 0 {
            let color = colorData.first!
            textView.backgroundColor = UIColor(hexString: color.backgroundColor)
        } else {
            textView.backgroundColor = .white
        }
        view.backgroundColor = .white
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(35)
        }
        
        textView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
        
        functionalView.addSubview(controlView)
        controlView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
        }
        
        controlView.addSubview(discardButton)
        
        discardButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        controlView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        functionalView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(controlView.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        
        functionalView.addSubview(colorView)
        functionalView.addSubview(fontView)
        
        colorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom)
            make.height.equalTo(100)
        }
        
        fontView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(colorView.snp.bottom).offset(10)
            make.height.equalTo(160)

        }
        
        colorView.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        
        fontColorCollectionView.dataSource = self
        fontColorCollectionView.delegate = self
        colorView.addSubview(fontColorCollectionView)
        fontColorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(65)
        }
        
        fontView.addSubview(fontLabel)
        fontLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        
        fontCollectionView.dataSource = self
        fontCollectionView.delegate = self
        fontView.addSubview(fontCollectionView)
        fontCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fontLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(135)
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
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        
    }
}

extension TextViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == fontColorCollectionView {
            return colors.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fontColorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontColorCell", for: indexPath) as! FontColorCell
            cell.backgroundColor = colors[indexPath.item]
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontCell", for: indexPath) as! FontCell
        cell.fontLabel.text = fontTypes[indexPath.item]
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == fontColorCollectionView {
            textColor = colors[indexPath.row]
            textLabel.textColor = textColor
        } else if collectionView == fontCollectionView {
            textFont = UIFont(name: fontTypes[indexPath.row], size: 20)!
            textLabel.font = textFont
        }
        
    }
    
}

extension TextViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        textLabel.text = updatedText
        textView.isHidden = updatedText.isEmpty
        return true
    }
}


