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
    @objc dynamic var text: String = ""
}
