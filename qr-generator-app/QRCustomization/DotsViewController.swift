//
//  DotsViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode
import RealmSwift
import PopupDialog

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
    
    let storeKit = StoreKitManger()
    
    var realmData = RealmData()
    
    var delegate: DotsDelegate?
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Dots"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return titleLabel
    }()
    
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
    
    let freeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Free Dots Styles"
        return label
    }()
    
    let freeView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    let freeDotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DotsCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let paidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Premium Dots Styles"
        return label
    }()
    
    let paidView: UIView = {
        let view = UIView()
        return view
    }()
    
    let paidDotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DotsCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let freePointPatterns: [String] = ["square","pointy"]
    let freePointClasses: [QRCodePixelShapeGenerator] = [QRCode.PixelShape.Square(), QRCode.PixelShape.Pointy()]
    
    let paidPointPatterns: [String] = ["circle","curvePixel","squircle"]
    let paidPointClasses: [QRCodePixelShapeGenerator] = [QRCode.PixelShape.Circle(), QRCode.PixelShape.CurvePixel(), QRCode.PixelShape.Squircle()]
    
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
        setupFreeLabel()
        setupFreeView()
        setupFreeDotsCollectionView()
        setupPaidLabel()
        setupPaidView()
        setupPaidDotsCollectionView()
        
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
    
     func showAlert() -> PopupDialog {
         let title = "You are trying to use a Premium feature!"
         let message = "Unlock access for premium customization of your QR code. Purchase once - use forever!"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        let buttonTwo = DefaultButton(title: "Unlock the Premium Dots!") { [weak self] in
            print("What a beauty!")
            let product = self?.storeKit.storeProducts[1]
            Task {
                print(try? await self?.storeKit.purchase(product!))
                self?.storeKit.isPurchasedDots = (try? await self?.storeKit.isPurchased(product!)) ?? false
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
