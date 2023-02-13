//
//  EyesViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode

class EyesViewController: UIViewController {

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
    
    
    let eyesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EyesCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let pointPatterns: [String] = ["eye_square","eye_circle", "eye_barsHorizontal", "eye_barsVertical", "eye_corneredPixels", "eye_leaf", "eye_pixels", "eye_roundedouter", "eye_roundedpointingin", "eye_roundedRect", "eye_squircle"]
    
    let eyesClasses: [QRCodeEyeShapeGenerator] = [QRCode.EyeShape.Square(), QRCode.EyeShape.Circle(), QRCode.EyeShape.RoundedRect(), QRCode.EyeShape.RoundedOuter(), QRCode.EyeShape.RoundedPointingIn(), QRCode.EyeShape.Leaf(), QRCode.EyeShape.Squircle(), QRCode.EyeShape.BarsHorizontal(), QRCode.EyeShape.BarsVertical(), QRCode.EyeShape.Pixels(), QRCode.EyeShape.CorneredPixels()]
    
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
        
        
        eyesCollectionView.dataSource = self
        eyesCollectionView.delegate = self
        functionalView.addSubview(eyesCollectionView)
        
        eyesCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.bottom.equalToSuperview().inset(30)
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func changeQRPattern(_ pattern: QRCodeEyeShapeGenerator) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.shape.eye = pattern
        let changed = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: changed!)
    }

}

extension EyesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! EyesCell
        cell.imageView.image = UIImage(named: pointPatterns[indexPath.item])
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pattern: QRCodeEyeShapeGenerator = eyesClasses[indexPath.item]
        qrImageView.image = changeQRPattern(pattern)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
