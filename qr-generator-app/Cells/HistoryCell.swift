//
//  HistoryCell.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 21.02.2023.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    let qrImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 238/255, green: 188/255, blue: 0/255, alpha: 1)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .white
//        layer.cornerRadius = bounds.height / 2
//        layer.masksToBounds = true
        setupImage()
        setupTypeLabel()
        setupContentLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

extension HistoryCell {
    func setupImage() {
        addSubview(qrImageView)
        qrImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().dividedBy(1.8)
            make.width.equalTo(qrImageView.snp.height)

        }
    }

    func setupTypeLabel() {
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(qrImageView.snp.right).offset(20)
        }
    }

    func setupContentLabel() {
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(6)
            make.left.equalTo(qrImageView.snp.right).offset(20)
        }
    }
}
