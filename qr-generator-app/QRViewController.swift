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

/*
 
 1) Make functionalView higher
 2) Change background to white
 2) Update functions ierarchy
 
 */

class QRViewController: UIViewController {
    
    let qrImageView = UIImageView()
    var data = ""
    
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
    
    let colorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Color", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openColorVC), for: .touchUpInside)
        return button
    }()
    
    let dotsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dots", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openDotsVC), for: .touchUpInside)
        return button
    }()
    
    let eyesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Eyes", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openEyesVC), for: .touchUpInside)
        return button
    }()
    
    let logoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openLogoVC), for: .touchUpInside)
        return button
    }()
    
    let textButton: UIButton = {
        let button = UIButton()
        button.setTitle("Text", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openTextVC), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let saveButton = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        let titleLabel = UILabel()
        titleLabel.text = "Edit"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        navigationItem.titleView = titleLabel
        setupUI()
    }
    
    @objc func backButtonTapped() {
        // Handle the back button tap
        showQuitAlert()
    }
    
    @objc func saveButtonTapped() {
        // Handle the back button tap
        showQuitAlert()
    }
    
    func setupUI() {
        setGradient()
        setupImageView()
        setupTextView()
        setupTextLabel()
        setupButtonsView()
        setupButtonInnerView()
        setupEyesButton()
        setupTextButton()
        setupLogoButton()
        setupColorButton()
        setupDotsButton()
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
                realm.deleteAll()
            }
            self.navigationController?.popToRootViewController(animated: true)
            
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



