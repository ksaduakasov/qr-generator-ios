//
//  LogoViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode
import RealmSwift
import PopupDialog

protocol LogoDelegate {
    func qrLogoChanged(logo: Data?)
}

class LogoViewController: UIViewController {
    
    let storeKit = StoreKitManger()
    
    var realmData = RealmData()
    
    var delegate: LogoDelegate?
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Logo"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return titleLabel
    }()
    
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
    
    let removeLogoButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Remove logo"
        filled.buttonSize = .large
        filled.image = UIImage(systemName: "nosign")
        filled.imagePlacement = .trailing
        filled.imagePadding = 10
        filled.baseBackgroundColor = UIColor(red: 88/255, green: 51/255, blue: 122/255, alpha: 1)
        
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.addTarget(self, action: #selector(removeLogo), for: .touchUpInside)
        return button
    }()
    
    let freeLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium Icons"
        label.textColor = .white
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
    
    
    let pickerButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Choose photo"
        filled.buttonSize = .large
        filled.subtitle = "from your gallery"
        filled.image = UIImage(systemName: "photo.stack")
        filled.baseBackgroundColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        
        filled.imagePlacement = .trailing
        filled.imagePadding = 10
        
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        return button
    }()
    
    let freeLogoTemplates: [String] = ["wpp", "messenger", "paypal", "crypto", "spotify", "tiktok1","instagram1", "twitter1", "facebook1", "youtube1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        navigationItem.titleView = titleLabel
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
        setupPickerButton()
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
    
    
    @objc func uploadImage() {
        if !storeKit.isPurchasedLogo {
            let alert = showAlert()
            self.present(alert, animated: true, completion: nil)
        } else {
            ImagePickerManager().pickImage(self) { [weak self] image in
                self?.selectedLogo = image.updateImageOrientionUpSide()
                self?.qrImageView.image = self?.QRWithLogo(self?.selectedLogo)
            }
        }
        
    }
    
     func showAlert() -> PopupDialog {
        let title = "You are trying to use a Premium feature!"
        let message = "Unlock access for inserting your logo of your QR code. Purchase once - use forever!"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        let buttonTwo = DefaultButton(title: "Unlock the Premium Logos!") { [weak self] in
            print("What a beauty!")
            let product = self?.storeKit.storeProducts[3]
            Task {
                print(try? await self?.storeKit.purchase(product!))
                self?.storeKit.isPurchasedLogo = (try? await self?.storeKit.isPurchased(product!)) ?? false
            }

        }
        
        // Create buttons
        let buttonOne = CancelButton(title: "No, thank you!", height: 200) {
            print("You canceled the car dialog.")
        }
        
        popup.addButtons([buttonTwo, buttonOne])
        return popup
    }
    
}
