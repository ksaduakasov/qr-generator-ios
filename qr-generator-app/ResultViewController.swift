//
//  ResultViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 20.02.2023.
//

import UIKit
import QRCode
import RealmSwift

class ResultViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "QR Code Saved"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    let qrImageView = UIImageView()
    var data = ""
    
    let textView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let textLabel = UILabel()
    
    let toolsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tools"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let shareButton: UIView = {
        let view = UIView()
        return view
    }()
    
    let shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.and.arrow.up")
        imageView.tintColor = .white
        return imageView
    }()
    
    let shareLabel: UILabel = {
        let label = UILabel()
        label.text = "Share"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    let saveQRButton: UIView = {
        let view = UIView()
        return view
    }()
    
    let saveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        imageView.tintColor = .white
        return imageView
    }()
    
    let saveLabel: UILabel = {
        let label = UILabel()
        label.text = "Save"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    var realmData = RealmData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI() {
        setGradient()
        setupNavigationItems()
        setupQRImage()
        setupTextView()
        setupTextLabel()
        setupToolsLabel()
        setupShareButton()
        setupShareLabel()
        setupQRSaveButton()
        setupQRSaveLabel()
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
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func homeButtonTapped() {
        if !textView.isHidden {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: qrImageView.frame.width, height: qrImageView.frame.height + textView.frame.height))
            
            let image = renderer.image { context in
                qrImageView.layer.render(in: context.cgContext)
            }
            let imageData = image.jpegData(compressionQuality: 1.0)
            let contentData = self.data
            realmData.addQRImage(imageData!, data, QRContentViewController.contentType)
        } else {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: qrImageView.frame.width, height: qrImageView.frame.height))
            
            let image = renderer.image { context in
                qrImageView.layer.render(in: context.cgContext)
            }
            let imageData = image.jpegData(compressionQuality: 1.0)
            let contentData = self.data
            realmData.addQRImage(imageData!, data, QRContentViewController.contentType)
        }
        
        
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
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func shareButtonTapped() {
        if !textView.isHidden {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: qrImageView.frame.width, height: qrImageView.frame.height + textView.frame.height))
            let image = renderer.image { context in
                qrImageView.layer.render(in: context.cgContext)
            }
            let imageShare = [image]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        } else {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: qrImageView.frame.width, height: qrImageView.frame.height))
            
            let image = renderer.image { context in
                qrImageView.layer.render(in: context.cgContext)
            }
            let imageShare = [image]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func saveButtonTapped() {
        if !textView.isHidden {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: qrImageView.frame.width, height: qrImageView.frame.height + textView.frame.height))
            let image = renderer.image { context in
                qrImageView.layer.render(in: context.cgContext)
            }
            print("saveButtonTapped")
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: image)
            let alert = UIAlertController(title: nil, message: "QR code successfully saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(okAction)
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: qrImageView.frame.width, height: qrImageView.frame.height))
            let image = renderer.image { context in
                qrImageView.layer.render(in: context.cgContext)
            }
            print("saveButtonTapped")
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: image)
            let alert = UIAlertController(title: nil, message: "QR code successfully saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(okAction)
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        

        
    }
    
    
}


