//
//  ResultViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 20.02.2023.
//

import UIKit

class ResultViewController: UIViewController {
    
    let qrImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        let homeButton = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(homeButton))
//        navigationItem.rightBarButtonItem = homeButton
        let titleLabel = UILabel()
        titleLabel.text = "Edit"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        navigationItem.titleView = titleLabel
        setupUI()
    }
    
    func setupUI() {
// MARK: -ToDo
//        setGradient()
//        setupImageView()
    }


}
