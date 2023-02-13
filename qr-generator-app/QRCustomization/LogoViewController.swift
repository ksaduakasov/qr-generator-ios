//
//  LogoViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode

class LogoViewController: UIViewController {

    let qrImageView = UIImageView()
    var data = ""
    var foregroundColor: UIColor = .black
    var backgroundColor: UIColor = .clear
    
    let functionalView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    
    let logoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyesCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let logoPatterns: [String] = ["eye_square","eye_circle", "eye_barsHorizontal", "eye_barsVertical", "eye_corneredPixels", "eye_leaf", "eye_pixels", "eye_roundedouter", "eye_roundedpointingin", "eye_roundedRect", "eye_squircle", "square","circle","curvePixel","roundedRect","horizontal","vertical","roundedPath","squircle","pointy", "eye_colorstyles"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        qrImageView.image = generateQRCode(from: data)
        view.addSubview(qrImageView)
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
        
        view.addSubview(functionalView)
        
        functionalView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
        
        
        logoCollectionView.dataSource = self
        logoCollectionView.delegate = self
        functionalView.addSubview(logoCollectionView)
        
        logoCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.bottom.equalToSuperview().inset(30)
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func QRWithLogo(_ imageName: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.logoTemplate = QRCode.LogoTemplate.SquareCenter(
            image: (UIImage(named: imageName)?.cgImage)!,
            inset: 8)
        let qrCodeWithLogo = doc.uiImage(dimension: 300)
        return qrCodeWithLogo
    }

}

extension LogoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logoPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        cell.imageView.image = UIImage(named: logoPatterns[indexPath.item])
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        qrImageView.image = QRWithLogo(logoPatterns[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
