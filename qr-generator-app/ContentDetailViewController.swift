//
//  ContentDetailViewController.swift
//  kettkal
//
//  Created by Kalbek Saduakassov on 07.02.2023.
//
import UIKit

class ContentDetailViewController: UIViewController {
    
    let titleLabel = UILabel()
    let dataTextField = UITextField()
    let saveButton = UIButton()
    var cellTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        titleLabel.text = cellTitle
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        dataTextField.placeholder = "Enter \(cellTitle) data"
        view.addSubview(dataTextField)
        dataTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(dataTextField.snp.bottom).offset(120)
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
        
       
        
        
    }
    
    @objc func saveButtonTapped() {
        guard let data = dataTextField.text, !data.isEmpty else {
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
