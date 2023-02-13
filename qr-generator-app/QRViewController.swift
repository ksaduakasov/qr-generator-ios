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

class QRViewController: UIViewController {
    
    let qrImageView = UIImageView()
    var data = ""
    
    let greenView = UIView()
    let buttonTitles = ["Template", "Color", "Dots", "Eyes", "Logo", "Text"]
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        qrImageView.image = generateQRCode(from: data)
        view.addSubview(qrImageView)
        
        qrImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(300)
        }
        
        greenView.backgroundColor = .green
        greenView.layer.cornerRadius = 20
        view.addSubview(greenView)
        
        greenView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(100)
            make.left.right.bottom.equalToSuperview()
        }
        
        for i in 0..<buttonTitles.count {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitles[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.layer.cornerRadius = 20
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            
            greenView.addSubview(button)
            buttons.append(button)
        }
        
        for i in 0..<buttons.count {
            buttons[i].snp.makeConstraints { make in
                make.width.equalToSuperview().dividedBy(4)
                make.height.equalTo(80)
                
                if i < 3 {
                    make.top.equalToSuperview().offset(80)
                } else {
                    make.bottom.equalToSuperview().offset(-80)
                }
                
                if i % 3 == 0 {
                    make.left.equalToSuperview().offset(20)
                } else if i % 3 == 1 {
                    make.centerX.equalToSuperview()
                } else {
                    make.right.equalToSuperview().offset(-20)
                }
            }
            buttons[i].addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        if let index = buttons.firstIndex(of: sender) {
            switch buttonTitles[index] {
            case "Template":
                let templateVC = TemplateViewController()
                navigationController?.pushViewController(templateVC, animated: true)
            case "Color":
                let colorVC = ColorViewController()
//                colorVC.modalPresentationStyle = .fullScreen
                colorVC.data = data
//                present(colorVC, animated: true)
                navigationController?.pushViewController(colorVC, animated: true)
            case "Dots":
                let dotsVC = DotsViewController()
//                dotsVC.modalPresentationStyle = .fullScreen
                dotsVC.data = data
//                present(dotsVC, animated: true)
                navigationController?.pushViewController(dotsVC, animated: true)
            case "Eyes":
                let eyesVC = EyesViewController()
//                eyesVC.modalPresentationStyle = .fullScreen
                eyesVC.data = data
//                present(eyesVC, animated: true)
                navigationController?.pushViewController(eyesVC, animated: true)
            case "Logo":
                let logoVC = LogoViewController()
//                logoVC.modalPresentationStyle = .fullScreen
                logoVC.data = data
//                present(logoVC, animated: true)
                navigationController?.pushViewController(logoVC, animated: true)
            case "Text":
                let textVC = TextViewController()
//                textVC.modalPresentationStyle = .fullScreen
                textVC.data = data
//                present(textVC, animated: true)
                navigationController?.pushViewController(textVC, animated: true)
            default:
                break
            }
        }
    }
        
       
    
    func generateQRCode(from string: String) -> UIImage? {
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        let generated = doc.cgImage(CGSize(width: 800, height: 800))
        return UIImage(cgImage: generated!)
    }
    
}
