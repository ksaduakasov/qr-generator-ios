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
    
    var realmData = RealmData()
    
    var backgroundColor: String?
    var foregroundColor: String?
    var dots: QRCodePixelShapeGenerator?
    var eyes: QRCodeEyeShapeGenerator?
    var logo: Data?
    var text = ""
    
    let greenView = UIView()
    let buttonTitles = ["Template", "Color", "Dots", "Eyes", "Logo", "Text"]
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI() {
        setupImageView()
        setupGreenView()
        setupButtonStructure()
        setupButtonConstraints()
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
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
}



