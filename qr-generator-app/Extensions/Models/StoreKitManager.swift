//
//  StoreKitManager.swift
//  qr-generator-app
//
//  Created by Kalbek Saduakassov on 28.02.2023.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

class StoreKitManger: ObservableObject {
    
    var isPurchasedColor = false
    var isPurchasedDots  = false
    var isPurchasedEyes  = false
    var isPurchasedLogo  = false
    var isPurchasedText  = false

        
    var storeProducts: [Product] = []
    var purchasedCourses : [Product] = []
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    //maintain a plist of products
    private let productDict: [String : String]
    
    init() {
        
        if let plistPath = Bundle.main.path(forResource: "PropertyList", ofType: "plist"),
           //get the list of products
           let plist = FileManager.default.contents(atPath: plistPath) {
            productDict = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String : String]) ?? [:]
        } else {
            productDict = [:]
        }
        
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await fetchProducts()
            await updateCustomerProductStatus()
            isPurchasedColor = (try? await isPurchased(storeProducts[0])) ?? false
            isPurchasedDots = (try? await isPurchased(storeProducts[1])) ?? false
            isPurchasedEyes = (try? await isPurchased(storeProducts[2])) ?? false
            isPurchasedLogo = (try? await isPurchased(storeProducts[3])) ?? false
            isPurchasedText = (try? await isPurchased(storeProducts[4])) ?? false

        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //iterate through any transactions that don't come from a direct call to 'purchase()'
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    //the transaction is verified, deliver the content to the user
                    await self.updateCustomerProductStatus()
                    
                    //Always finish a transaction
                    await transaction.finish()
                } catch {
                    //storekit has a transaction that fails verification, don't delvier content to the user
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    
    func fetchProducts() async {
        do {
            //using the Product static method products to retrieve the list of products
            storeProducts = try await Product.products(for: productDict.values)
            
            // iterate the "type" if there are multiple product types.
        } catch {
            print("Failed - error retrieving products \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        //make a purchase request - optional parameters available
        let result = try await product.purchase()
        
        // check the results
        switch result {
        case .success(let verificationResult):
            //Transaction will be verified for automatically using JWT(jwsRepresentation) - we can check the result
            let transaction = try checkVerified(verificationResult)
            
            //the transaction is verified, deliver the content to the user
            await updateCustomerProductStatus()
            
            //always finish a transaction - performance
            await transaction.finish()
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
        
    }
    
    //Generics - check the verificationResults
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //check if JWS passes the StoreKit verification
        switch result {
        case .unverified:
            //failed verificaiton
            throw StoreError.failedVerification
        case .verified(let signedType):
            //the result is verified, return the unwrapped value
            return signedType
        }
        
    }
    
    func updateCustomerProductStatus() async {
        var purchasedCourses: [Product] = []
        
        //iterate through all the user's purchased products
        for await result in Transaction.currentEntitlements {
            do {
                //again check if transaction is verified
                let transaction = try checkVerified(result)
                // since we only have one type of producttype - .nonconsumables -- check if any storeProducts matches the transaction.productID then add to the purchasedCourses
                if let course = storeProducts.first(where: { $0.id == transaction.productID}) {
                    purchasedCourses.append(course)
                }
                
            } catch {
                //storekit has a transaction that fails verification, don't delvier content to the user
                print("Transaction failed verification")
            }
            
            //finally assign the purchased products
            self.purchasedCourses = purchasedCourses
        }
    }
    
    //check if product has already been purchased
    func isPurchased(_ product: Product) async throws -> Bool {
        //as we only have one product type grouping .nonconsumable - we check if it belongs to the purchasedCourses which ran init()
        return purchasedCourses.contains(product)
    }
}
