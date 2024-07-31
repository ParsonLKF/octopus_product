//
//  BookmarkManager.swift
//  OctopusProduct
//
//  Created by Parson Lam on 1/5/2024.
//

import Foundation

class BookmarkManager {
    
    let defaults = UserDefaults.standard
    
    private let code = "code"
    private let description = "description"
    private let display_name = "display_name"
    private let full_name = "full_name"
    private let tariff_id = "tariff_id"
    
    static private let mgr = BookmarkManager()
    static func shareInstance() -> BookmarkManager {
        return mgr
    }
    
    func saveProduct(product : Product, tariff : DebitDetail) {
        defaults.set(product.code, forKey: code)
        defaults.set(product.description, forKey: description)
        defaults.set(product.display_name, forKey: display_name)
        defaults.set(product.full_name, forKey: full_name)
        defaults.set(tariff.code, forKey: tariff_id)
        
        defaults.synchronize()
    }
    
    func removeSavedProduct() {
        defaults.removeObject(forKey: code)
        defaults.removeObject(forKey: description)
        defaults.removeObject(forKey: display_name)
        defaults.removeObject(forKey: full_name)
        defaults.removeObject(forKey: tariff_id)
        
        defaults.synchronize()
    }
    
    func getProduct() -> (product: Product, tariff : DebitDetail)? {
        if let pid = defaults.value(forKey: code) as? String,
           let desc = defaults.value(forKey: description)  as? String,
           let dis = defaults.value(forKey: display_name)  as? String,
           let ful = defaults.value(forKey: full_name)  as? String,
           let cod = defaults.value(forKey: tariff_id) as? String {
            
            let product = Product(code: pid, full_name: ful, display_name: dis, description: desc)
            let tariff = DebitDetail(code: cod)
            
            return (product, tariff)
         }
        
        return nil
    }
    
    func isSavedProduct(product : Product, tariff : DebitDetail) -> Bool {
        if let (savedProduct, savedTariff) =  getProduct() {
            if product.code == savedProduct.code && savedTariff.code == tariff.code {
                return true
            }
        }
        
        return false
    }
}
