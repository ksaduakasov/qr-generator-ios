//
//  QRPreviewViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 21.02.2023.
//

import UIKit

class QRPreviewViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "QR Code Saved"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
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
    
    let qrImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        setupNavigationItems()
        setupQRImage()
        setupToolsLabel()
        setupShareButton()
        setupShareLabel()
        setupQRSaveButton()
        setupQRSaveLabel()
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func homeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func shareButtonTapped() {
        let imageShare = [qrImageView.image!]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        
        print("saveButtonTapped")
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: qrImageView.image!)
        let alert = UIAlertController(title: nil, message: "QR code successfully saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(okAction)

        // Present the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
