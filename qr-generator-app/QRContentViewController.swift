//
//  QRContentViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit
import SnapKit

class QRContentViewController: UIViewController {
    
    static var contentType: String = ""
    
    struct ContentInfo {
        let image: String
        let title: String
    }
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return titleLabel
    }()
    
    let textView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose the type of content"
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        let placeholderString = NSAttributedString(string: "Please fill in the text here", attributes: [.foregroundColor: UIColor.lightGray])
        let style = NSMutableParagraphStyle()
        let attributedPlaceholder = NSMutableAttributedString(attributedString: placeholderString)
        attributedPlaceholder.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: placeholderString.length))
        textField.attributedPlaceholder = attributedPlaceholder
        textField.isHidden = true
        return textField
    }()
    
    let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: "optionsCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        layout.minimumLineSpacing = 10
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        layout.scrollDirection = .vertical
        return collectionView
    }()
    
    
    let data: [ContentInfo] = [
        ContentInfo(image: "text", title: "Text"),
        ContentInfo(image: "phone", title: "Phone"),
        ContentInfo(image: "website", title: "Website"),
        ContentInfo(image: "instagram", title: "Instagram"),
        ContentInfo(image: "tiktok", title: "TikTok"),
        ContentInfo(image: "facebook", title: "Facebook"),
        ContentInfo(image: "twitter", title: "Twitter"),
        ContentInfo(image: "youtube", title: "YouTube")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI() {
        setGradient()
        setupNavigationItems()
        setupTextView()
        setupTextLabel()
        setupTextField()
        setupCollectionView()
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func createButtonTapped() {
        guard let data = textField.text, !data.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter data in the text field", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let qrVC = QRViewController()
        qrVC.data = data
        navigationController?.pushViewController(qrVC, animated: true)
    }
    
}
