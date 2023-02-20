//
//  WelcomeViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit
import SnapKit
import RealmSwift

class WelcomeViewController: UIViewController {
    
    lazy var realm:Realm = {
        let config = Realm.Configuration(
            schemaVersion: 4)
        // Use this configuration when opening realms
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        return try! Realm()
    }()
    
    let createQRView: UIView = {
        let view = UIView()
        return view
    }()
    
    let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Create QR Code"
        label.textColor = .white
        return label
    }()
    
    let buttonImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "qr-code")
        return imageView
    }()
    
    let historyButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Show history"
        filled.buttonSize = .large
        filled.image = UIImage(systemName: "archivebox.circle.fill")
        filled.imagePlacement = .trailing
        filled.imagePadding = 10
//        filled.baseBackgroundColor = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1)

        let button = UIButton(configuration: filled, primaryAction: nil)
        button.addTarget(self, action: #selector(openHistory), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(realm.configuration.fileURL!)
        setupUI()
    }
    
    func setupUI() {
        setGradient()
        setupButton()
        setupButtonImage()
        setupButtonLabel()
        setupHistoryButton()
    }
    
    @objc func goToSelection() {
        let qrContentVC = QRContentViewController()
        navigationController?.pushViewController(qrContentVC, animated: true)
    }
    
    @objc func openHistory() {
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }

    
}

