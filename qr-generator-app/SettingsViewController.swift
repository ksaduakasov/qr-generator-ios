//
//  SettingsViewController.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 02.03.2023.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    let historyButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Show history"
        filled.buttonSize = .large
        filled.imagePlacement = .trailing
        filled.baseBackgroundColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 14)
        let button = UIButton(configuration: filled)
        button.addTarget(self, action: #selector(openHistory), for: .touchUpInside)
        button.titleLabel!.text = "Show History"
        return button
    }()
    
    let restoreButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Restore Purchases"
        filled.buttonSize = .large
        filled.imagePlacement = .trailing
        filled.baseBackgroundColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 14)
        let button = UIButton(configuration: filled)
        button.addTarget(self, action: #selector(restorePurchases), for: .touchUpInside)
        button.titleLabel!.text = "Show History"
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(historyButton)
        historyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.height.equalTo(view.snp.width).dividedBy(6)
            make.width.equalTo(view.snp.height).dividedBy(3.5)
        }
        
        view.addSubview(restoreButton)
        restoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(80)
            make.height.equalTo(view.snp.width).dividedBy(6)
            make.width.equalTo(view.snp.height).dividedBy(3.5)
        }
        
        setupUI()
    }
    
    func setupUI() {
        setGradient()
        setupNavigationItems()
    }
    
    @objc func openHistory() {
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @objc func restorePurchases() {
        Task {
            try? await AppStore.sync()
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SettingsViewController {
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 50/255, green: 47/255, blue: 82/255, alpha: 1).cgColor
        let end = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupNavigationItems() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleLabel
    }
}


