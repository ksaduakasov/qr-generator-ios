//
//  DotsViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 09.02.2023.
//

import UIKit
import QRCode

//enum Dots {
//    case square
//    case circle
//    case curvePixel
//    case roundedRect
//    case horizontal
//    case vertical
//    case roundedPath
//    case squircle
//    case pointy
//}

class DotsViewController: UIViewController {
    
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
    
    
    let pointsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DotsCell.self, forCellWithReuseIdentifier: "DotsCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let pointPatterns: [String] = ["square","circle","curvePixel","squircle","pointy"]
    let pointClasses: [QRCodePixelShapeGenerator] = [QRCode.PixelShape.Square(), QRCode.PixelShape.Circle(), QRCode.PixelShape.CurvePixel(), QRCode.PixelShape.Squircle(), QRCode.PixelShape.Pointy()]
    
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
        
        
        pointsCollectionView.dataSource = self
        pointsCollectionView.delegate = self
        functionalView.addSubview(pointsCollectionView)
        
        pointsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.bottom.equalToSuperview().inset(30)
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
    func changeQRPattern(_ pattern: QRCodePixelShapeGenerator) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.shape.onPixels = pattern
        let changed = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: changed!)
    }
    
    
}

extension DotsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DotsCell", for: indexPath) as! DotsCell
        cell.imageView.image = UIImage(named: pointPatterns[indexPath.item])
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPattern: QRCodePixelShapeGenerator = pointClasses[indexPath.item]
        qrImageView.image = changeQRPattern(selectedPattern)
//        switch indexPath.row {
//        case 0:
//            qrImageView.image = changeQRPattern(QRCode.PixelShape.Square())
//        case 1:
//            print("hello")
//        case 2:
//            print("hello")
//        case 3:
//            print("hello")
//        case 4:
//            print("hello")
//        case 5:
//            print("hello")
//        case 6:
//            print("hello")
//        case 7:
//            print("hello")
//        case 8:
//            print("hello")
//        default:
//            print("hello")
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 500)
    }
}
