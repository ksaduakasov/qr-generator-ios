//
//  QRCodeText.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 14.02.2023.
//

import Foundation
import UIKit
import QRCode
import RealmSwift

class QRCodeText: Object {
    @objc dynamic var textContent: String = ""
    @objc dynamic var textFont: String = ""
    @objc dynamic var textColor: String = ""
}
