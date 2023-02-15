//
//  WelcomeViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit
import SnapKit
import RealmSwift

class WelcomeViewController: UIViewController {
    
    let realm = try! Realm()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Table View", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(goToTableView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(realm.configuration.fileURL!)
        setupUI()
    }
    
    func setupUI() {
        setupButton()
    }
    
    @objc func goToTableView() {
        let secondVC = QRContentViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
}

