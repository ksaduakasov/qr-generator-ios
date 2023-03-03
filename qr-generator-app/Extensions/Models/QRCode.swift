//
//  QRCode.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 20.02.2023.
//

import Foundation
import UIKit
import QRCode
import RealmSwift

class QRCodeImage: Object {
    @objc dynamic var qrCodeImage: Data? = nil
    @objc dynamic var qrCodeData: String = ""
    @objc dynamic var qrCodeDataType: String = ""
}
