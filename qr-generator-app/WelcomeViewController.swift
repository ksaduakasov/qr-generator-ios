//
//  WelcomeViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    let button = UIButton()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            button.setTitle("Go to Table View", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(goToTableView), for: .touchUpInside)
            view.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(50)
            }
        }
        
        @objc func goToTableView() {
            let secondVC = QRContentViewController()
            navigationController?.pushViewController(secondVC, animated: true)
        }

}
