//
//  QRViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit
import SnapKit
import CoreImage
import QRCode
import RealmSwift

class QRViewController: UIViewController {
    
    let qrImageView = UIImageView()
    var data = ""
    
    let editLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Edit"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return titleLabel
    }()
    
    let textView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let textLabel = UILabel()
    
    var realmData = RealmData()
    
    var backgroundColor: String?
    var foregroundColor: String?
    var dots: QRCodePixelShapeGenerator?
    var eyes: QRCodeEyeShapeGenerator?
    var logo: Data?
    var textContent = ""
    var textColor = ""
    var textFont = ""
    
    let buttonsView = UIView()
    let buttonInnerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let aboveView: UIView = {
        let view = UIView()
        return view
    }()
    
    let belowView: UIView = {
        let view = UIView()
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        return view
    }()
    
    let colorButton: UIView = {
        let view = UIView()
        return view
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.textColor = .black
        return label
    }()
    
    let colorImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "color")
        return imageView
    }()
    
    let dotsButton: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let dotsLabel: UILabel = {
        let label = UILabel()
        label.text = "Dots"
        label.textColor = .black
        return label
    }()
    
    let dotsImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "circleLogo")
        return imageView
    }()
    
    let eyesButton: UIView = {
        let view = UIView()
        return view
    }()
    
    let eyesLabel: UILabel = {
        let label = UILabel()
        label.text = "Eyes"
        label.textColor = .black
        return label
    }()
    
    let eyesImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "eyeLogo")
        return imageView
    }()
    
    let logoButton: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Logo"
        label.textColor = .black
        return label
    }()
    
    let logoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "cleverest")
        return imageView
    }()
    
    let textButton: UIView = {
        let view = UIView()
        return view
    }()
    
    let textBtnLabel: UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.textColor = .black
        return label
    }()
    
    let textImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "textButton")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc func backButtonTapped() {
        // Handle the back button tap
        showQuitAlert()
    }
    
    @objc func saveButtonTapped() {
        let vc = ResultViewController()
        vc.data = data
//        vc.qrImageView = qrImageView
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        setGradient()
        setNavigationItems()
        setupImageView()
        setupTextView()
        setupTextLabel()
        setupButtonsView()
        setupButtonInnerView()
        setupColorButton()
        setupDotsButton()
        setupEyesButton()
        setupLogoButton()
        setupTextButton()

        
        
        //        setupButtonConstraints()
    }
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1).cgColor
        let end = UIColor(red: 244/255, green: 245/255, blue: 248/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func showQuitAlert() {
        let alert = UIAlertController(title: "Your QR code is not saved.", message: "All changes will be lost. Are you sure to quit?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No, get back", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let quitAction = UIAlertAction(title: "Yes, quit", style: .destructive) { _ in
            // Delete all data from Realm
            let realm = try! Realm()
            try! realm.write {
                let color = realm.objects(QRCodeColor.self)
                let dots = realm.objects(QRCodeDots.self)
                let eyes = realm.objects(QRCodeEyes.self)
                let logo = realm.objects(QRCodeLogo.self)
                let text = realm.objects(QRCodeText.self)

                realm.delete(color)
                realm.delete(dots)
                realm.delete(eyes)
                realm.delete(logo)
                realm.delete(text)

            }
            self.navigationController?.popViewController(animated: true)
            
        }
        alert.addAction(quitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func openColorVC() {
        openColorViewController()
        
    }
    
    @objc func openDotsVC() {
        openDotsViewController()
        
    }
    
    @objc func openEyesVC() {
        openEyesViewController()
        
    }
    
    @objc func openLogoVC() {
        openLogoViewController()
    }
    
    @objc func openTextVC() {
        openTextViewController()
        
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
    
}



