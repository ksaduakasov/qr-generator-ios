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
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.2
        textField.textAlignment = .center
        let placeholderString = NSAttributedString(string: "Please fill in the text here...", attributes: [.foregroundColor: UIColor.lightGray])
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedPlaceholder = NSMutableAttributedString(attributedString: placeholderString)
        attributedPlaceholder.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: placeholderString.length))
        textField.attributedPlaceholder = attributedPlaceholder
        return textField
    }()
    
    let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
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
    
    
    let aboveView: UIView = {
        let view = UIView()
        return view
    }()
    
    let belowView: UIView = {
        let view = UIView()
        return view
    }()
    
    let fontButton1: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    let fontButton2: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    let fontButton3: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    let fontButton4: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    let fontButton5: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    let fontButton6: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    let fontButton7: UIButton = {
        let button = UIButton()
        button.setTitle("fontButton7", for: .normal)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        return button
    }()
    
    let fontButton8: UIButton = {
        let button = UIButton()
        button.setTitle("fontButton8", for: .normal)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        return button
    }()
    
    let fontButton9: UIButton = {
        let button = UIButton()
        button.setTitle("fontButton9", for: .normal)
        button.addTarget(self, action: #selector(changeFont), for: .touchUpInside)
        return button
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
    
    let fontTypes = ["AmericanTypewriter", "Avenir-BookOblique", "Copperplate", "Didot", "GillSans-SemiBold", "MarkerFelt-Thin", "Menlo-Regular"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        textField.delegate = self
        textField.inputAccessoryView = toolbar
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
        setupTextField()
        setupColorLabel()
        setupColorView()
        setupFontColorCollectionView()
        setupFontLabel()
        setupFontView()
        setupAboveView()
        setupBelowView()
        setupFontButtons()
        
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
    
    @objc func changeFont(_ sender: UIButton) {
        switch sender {
        case fontButton1:
            selectedTextFont = UIFont(name: fontTypes[0], size: 20)!
            textLabel.font = selectedTextFont
        case fontButton2:
            selectedTextFont = UIFont(name: fontTypes[1], size: 20)!
            textLabel.font = selectedTextFont
        case fontButton3:
            selectedTextFont = UIFont(name: fontTypes[2], size: 20)!
            textLabel.font = selectedTextFont
        case fontButton4:
            selectedTextFont = UIFont(name: fontTypes[3], size: 20)!
            textLabel.font = selectedTextFont
        case fontButton5:
            selectedTextFont = UIFont(name: fontTypes[4], size: 20)!
            textLabel.font = selectedTextFont
        case fontButton6:
            selectedTextFont = UIFont(name: fontTypes[5], size: 20)!
            textLabel.font = selectedTextFont
        default:
            print(2)
        }
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




