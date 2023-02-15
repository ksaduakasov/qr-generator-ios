//
//  TextViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.

import UIKit
import SnapKit
import QRCode
import RealmSwift

protocol TextDelegate {
    func qrTextChanged(textContent: String, textColor: String, textFont: String)
}

class TextViewController: UIViewController {
    
    var realmData = RealmData()
    
    var delegate: TextDelegate?

    let qrImageView = UIImageView()
    var data = ""
    
    var enteredText = String()
    var selectedTextColor = UIColor()
    var selectedTextFont = UIFont()
    
    var textViewBackgroundColor: String = ""
    let textView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let textLabel = UILabel()
    
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
        let placeholderString = NSAttributedString(string: "Please fill in the text here...", attributes: [.foregroundColor: UIColor.lightGray])
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
        setupTextField()
        setupColorView()
        setupFontView()
        setupColorLabel()
        setupFontColorCollectionView()
        setupFontLabel()
        setupFontCollectionView()
        
        setupTextFromRealm()
    }
    
    func setupTextFromRealm() {
        let textData = realmData.realm.objects(QRCodeText.self)
        if textData.count != 0 {
            let text = textData.first!
            enteredText = text.textContent
            print(self.enteredText.isEmpty)
            selectedTextColor = UIColor(hexString: text.textColor)
            selectedTextFont = UIFont(name: text.textFont, size: 20)!
        } else {
            enteredText = ""
            selectedTextColor = .black
            selectedTextFont = UIFont(name: "Arial", size: 20)!
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
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        print()
        let textData = realmData.realm.objects(QRCodeText.self)
        if textData.count == 0 {
            realmData.addText(enteredText, selectedTextColor.hexString, selectedTextFont.fontName)
        } else {
            let text = textData.first!
            realmData.updateText(text, enteredText, selectedTextColor.hexString, selectedTextFont.fontName)
        }
        delegate?.qrTextChanged(textContent: enteredText, textColor: selectedTextColor.hexString, textFont: selectedTextFont.description)
        dismiss(animated: true)
    }
}




