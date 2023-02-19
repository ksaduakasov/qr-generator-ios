//
//  LogoViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode
import RealmSwift

protocol LogoDelegate {
    func qrLogoChanged(logo: Data?)
}

class LogoViewController: UIViewController {
    
    var realmData = RealmData()
    
    var delegate: LogoDelegate?
    
    let qrImageView = UIImageView()
    var data = ""
    var selectedLogo: UIImage?
    
    var imagePicker = UIImagePickerController()
    
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
    
    let removeLogoButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Remove logo"
        config.buttonSize = .large
        config.baseBackgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)
        config.baseForegroundColor = UIColor.black
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(removeLogo), for: .touchUpInside)
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
    
    
    let freelogoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
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
    
    let paidlogoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyesCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let logoTemplates: [UIImage] = [UIImage(named:"eye_square")!,UIImage(named:"eye_circle")!, UIImage(named:"eye_barsHorizontal")!, UIImage(named:"eye_barsVertical")!, UIImage(named:"eye_corneredPixels")!, UIImage(named:"eye_leaf")!]
    
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
        setupRemoveLogoButton()
        setupFreeLabel()
        setupFreeView()
        setupFreeLogoCollectionView()
        setupPaidLabel()
        setupPaidView()
        setupPaidLogoCollectionView()
        setupLogoFromRealm()
    }
    
    func setupLogoFromRealm() {
        let logoData = realmData.realm.objects(QRCodeLogo.self)
        if logoData.count != 0 {
            let logo = logoData.first!
            if let logo = logo.logo {
                self.selectedLogo = UIImage(data: logo)
            }
        } else {
            self.selectedLogo = nil
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
    
    func QRWithLogo(_ image: UIImage?) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        realmData.getText(self.textView, self.textLabel)
        if image == nil {
            doc.logoTemplate = nil
        } else {
            doc.logoTemplate = QRCode.LogoTemplate.SquareCenter(
                image: (image?.cgImage)!,
                inset: 8)
        }
        let qrCodeWithLogo = doc.uiImage(dimension: 300)
        return qrCodeWithLogo
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        guard let logo = selectedLogo else {
            let logoData = realmData.realm.objects(QRCodeLogo.self)
            if logoData.count == 0 {
                realmData.addLogo(nil)
            } else {
                let logo = logoData.first!
                realmData.updateLogo(logo, nil)
            }
            delegate?.qrLogoChanged(logo: nil)
            dismiss(animated: true)
            return
        }
        let imageData = logo.jpegData(compressionQuality: 1.0)
        
        let logoData = realmData.realm.objects(QRCodeLogo.self)
        if logoData.count == 0 {
            realmData.addLogo(imageData ?? nil)
        } else {
            let logo = logoData.first!
            realmData.updateLogo(logo, imageData)
        }
        delegate?.qrLogoChanged(logo: imageData)
        dismiss(animated: true)
    }
    
    @objc func removeLogo() {
        selectedLogo = nil
        qrImageView.image = QRWithLogo(nil)
    }
    
}
