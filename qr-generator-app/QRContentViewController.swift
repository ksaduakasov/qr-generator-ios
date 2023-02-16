//
//  QRContentViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit
import SnapKit

class QRContentViewController: UIViewController {
    
    struct ContentInfo {
        let image: String
        let title: String
    }
    
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
        ContentInfo(image: "contact", title: "Contact"),
        ContentInfo(image: "facebook", title: "Facebook"),
        ContentInfo(image: "wifi", title: "Wi-Fi"),
        ContentInfo(image: "youtube", title: "YouTube"),
        ContentInfo(image: "text", title: "Text"),
        ContentInfo(image: "phone", title: "Phone"),
        ContentInfo(image: "website", title: "Website"),
        ContentInfo(image: "instagram", title: "Instagram"),
        ContentInfo(image: "contact", title: "Contact"),
        ContentInfo(image: "facebook", title: "Facebook"),
        ContentInfo(image: "wifi", title: "Wi-Fi"),
        ContentInfo(image: "youtube", title: "YouTube")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setGradient()
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(title: "CREATE", style: .plain, target: self, action: #selector(createButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            make.height.equalToSuperview().dividedBy(2.5)
        }
        
        textView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        
        textView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(5)
        }
        
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            make.height.equalToSuperview().dividedBy(3.5)
        }
        
        
    }
    
    @objc func backButtonTapped() {
        // Handle the back button tap
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


extension QRContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionsCell", for: indexPath) as! OptionsCell
        let item = data[indexPath.item]
        cell.imageLogo.image = UIImage(named: item.image)
        cell.title.text = item.title
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 5
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowColor = UIColor.black.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! OptionsCell
        selectedCell.isActive = true
        textLabel.text = selectedCell.title.text
        textField.isHidden = false
        print(selectedCell.isActive)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! OptionsCell
        selectedCell.isActive = false
        print(selectedCell.isActive)
    }
    
    
    
}

extension QRContentViewController {
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 110/255, green: 212/255, blue: 207/255, alpha: 1).cgColor
        let end = UIColor(red: 244/255, green: 245/255, blue: 248/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        view.layer.addSublayer(gradientLayer)
        
    }
    
    @objc func pageControlTapped(sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(item: currentPage*8, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}
