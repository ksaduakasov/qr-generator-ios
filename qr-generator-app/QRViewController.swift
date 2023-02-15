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
    
    let greenView = UIView()
    let buttonTitles = ["Template", "Color", "Dots", "Eyes", "Logo", "Text"]
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))

            // Set the UIBarButtonItem as the left bar button item for the navigation item
            navigationItem.leftBarButtonItem = backButton
        setupUI()
    }
    
    @objc func backButtonTapped() {
        // Handle the back button tap
        showQuitAlert()
    }
    
    func setupUI() {
        setupImageView()
        setupTextView()
        setupTextLabel()
        setupGreenView()
        setupButtonStructure()
        setupButtonConstraints()
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
    
    
    @objc func buttonTapped(sender: UIButton) {
        if let index = buttons.firstIndex(of: sender) {
            switch buttonTitles[index] {
            case "Template":
                openTemplateViewController()
            case "Color":
                openColorViewController()
            case "Dots":
                openDotsViewController()
            case "Eyes":
                openEyesViewController()
            case "Logo":
                openLogoViewController()
            case "Text":
                openTextViewController()
            default:
                break
            }
        }
    }
        
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        realmData.getColor(doc)
        realmData.getDots(doc)
        realmData.getEyes(doc)
        realmData.getLogo(doc)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
}



