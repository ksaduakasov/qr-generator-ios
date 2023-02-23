//
//  KSPurchase.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 23.02.2023.
//

import Foundation
import UIKit
import Purchases
import PopupDialog

class KSPurchase {
    init() {
        
    }
    
    func fetchPackage(completion: @escaping (Purchases.Package) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let offerings = offerings, error == nil else {
                return
            }
            guard let package = offerings.all.first?.value.availablePackages.first else { return }
            completion(package)
        }
    }
    
    func purchase(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
            guard let transaction = transaction, let info = info, error == nil, !userCancelled else {
                return
            }
            
            
        }
    }
    
    func hasPremium() -> Bool {
        var value = false
        Purchases.shared.purchaserInfo { info, error in
            guard let info = info, error == nil else { return }
            if info.entitlements.all["Premium"]?.isActive == true {
                value = true
                return
            }
            return
        }
        return value
    }
    
    func showAlertToGetPremium() -> PopupDialog {
        let title = "Upgrade to Premium!"
        let message = "Unlock access to all cusomization features  by getting a Premium Subscription"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        let buttonTwo = DefaultButton(title: "Upgrade to Premium!") {
            print("What a beauty!")
            self.fetchPackage { [weak self] package in
                self?.purchase(package: package)
            }
            

        }
        
        // Create buttons
        let buttonOne = CancelButton(title: "No, thank you!", height: 200) {
            print("You canceled the car dialog.")
        }
        
        popup.addButtons([buttonTwo, buttonOne])
        return popup
    }
    
}
