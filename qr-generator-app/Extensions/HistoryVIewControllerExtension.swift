//
//  HistoryVIewControllerExtension.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 20.02.2023.
//

import Foundation
import UIKit

extension HistoryViewController {
    func setupNavigationItems() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleLabel
    }
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        
        let start = UIColor(red: 50/255, green: 47/255, blue: 82/255, alpha: 1).cgColor
        let end = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1).cgColor
        
        gradientLayer.colors = [start, end]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        view.layer.addSublayer(gradientLayer)
        
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(20)
            
        }
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmData().getQRImages().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        let qrImages = RealmData().getQRImages()
        cell.qrImageView.image = UIImage(data: qrImages[indexPath.row].qrCodeImage!)
        cell.typeLabel.text = qrImages[indexPath.row].qrCodeDataType
        cell.contentLabel.text = qrImages[indexPath.row].qrCodeData
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height / 9
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qrImages = RealmData().getQRImages()
        let vc = QRPreviewViewController()
        vc.qrImageView.image = UIImage(data:qrImages[indexPath.row].qrCodeImage!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


