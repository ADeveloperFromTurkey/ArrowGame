//
//  StoreKitManager.swift
//  ArrowGame
//
//  Created by Yusuf Erdem Ongun on 28.07.2025.
//
import StoreKit
import SwiftUI // SwiftUI'ı import edin

class StorekitManager: ObservableObject {
    var productIds = ["allcostumes","200point"]
    @Published private(set) var products : [Product] = []
    @Published private(set) var purhapseproducts : [Product]  = []
    
    // userData property'si burada tanımlanmalı
    var appUserData: UserData // BURAYI DÜZELTTİK: appUserData property'si eklendi

    var updateListenerTask: Task<Void, Error>? = nil
    
    // Başlatıcı userData parametresi almalı
    init(userData: UserData) { // BURAYI DÜZELTTİK: init parametresi eklendi
        self.appUserData = userData // BURAYI DÜZELTTİK: userData'yı appUserData'ya atıyoruz
        updateListenerTask = listenForTransactions()
        
        Task {
            await request()
            await updateCustomerProduct()
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
            return Task.detached {
                //iterate for incoming transactions
                for await result in Transaction.updates {
                    do {
                        let transaction = try self.checkVerified(result)
                        
                        await self.updateCustomerProduct()
                        
                        await transaction.finish()
                        
                    }catch {
                        print("Transaction failed verification")
                    }
                }
            }
        }
        
    @MainActor
    func request() async {
        do {
            let storeProducts = try await Product.products(for: Set(productIds))
            for product in storeProducts {
                switch product.type {
                case .nonConsumable:
                    products.append(product)
                case .consumable:
                    products.append(product)
                default:
                    print("unknown ?")
                }
            }
        } catch {
            print("Failed to load product :(")
        }
    }
    
    @MainActor
    func updateCustomerProduct() async {
        var purchasedProducts : [Product] = []
        for await result in Transaction.currentEntitlements {
          do {
                let transications = try checkVerified(result)
                
              switch transications.productType {
              case .nonConsumable:
                  if let product = products.first(where: {$0 .id == transications.productID}) {
                      purchasedProducts.append(product)
                      if product.displayName == "Tüm Kostümleri Satın Al" {
                          self.appUserData.sahipOlunanOklar = self.appUserData.oklar // BURAYI DÜZELTTİK: self.appUserData kullanıldı
                          print(self.appUserData.sahipOlunanOklar)
                      }
                  }
              case .consumable:
                  if let product = products.first(where: {$0 .id == transications.productID}), product.displayName == "200 Puan" {
                      self.appUserData.para += 200 // BURAYI DÜZELTTİK: self.appUserData kullanıldı
                  }
              default:
                  break
              }
                    
            }catch{
                print(":(")
            }
        }
        self.purhapseproducts = purchasedProducts
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
            // Check whether the JWS passes StoreKit verification.
            switch result {
            case .unverified:
                // StoreKit parses the JWS, but it fails verification.
                throw StoreError.failedVerification
            case .verified(let safe):
                // The result is verified. Return the unwrapped value.
                return safe
            }
        }
    public enum StoreError: Error {
            case failedVerification
        }
    
    
}
