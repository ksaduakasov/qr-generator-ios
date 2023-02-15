//
//  QRCodeLogo.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 15.02.2023.
//

import Foundation
import UIKit
import QRCode
import RealmSwift

class QRCodeLogo: Object {
    @objc dynamic var logo: Data? = nil
}
