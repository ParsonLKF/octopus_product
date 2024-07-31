//
//  ConsumptionViewModel.swift
//  OctopusProduct
//
//  Created by Parson Lam on 30/4/2024.
//

import Foundation

@MainActor class ConsumptionViewModel : ObservableObject {
    
    @Published var data : [Consumption] = []
    @Published var dateString : String = ""
    @Published var isBookmark : Bool = false
    
    
    var product : Product?
    var debit : DebitDetail?
    
    func setData(product: Product, debit: DebitDetail) {
        self.product = product
        self.debit = debit
        
        if let product = self.product , let debit = self.debit {
            if BookmarkManager.shareInstance().isSavedProduct(product: product, tariff: debit) {
                isBookmark = true
            } else {
                isBookmark = false
            }
        }
    }
    
    func bookmark() {
        if let product = self.product , let debit = self.debit {
            if BookmarkManager.shareInstance().isSavedProduct(product: product, tariff: debit) {
                BookmarkManager.shareInstance().removeSavedProduct()
                isBookmark = false
            } else {
                BookmarkManager.shareInstance().saveProduct(product: product, tariff: debit)
                isBookmark = true
            }
        }
    }
    
    func fetch (product_code: String, tariff_code: String) {
        Task {
            data =  try await NetworkManager.shareInstance().getConsumption(product_code: product_code, tariff_code: tariff_code)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            dateString = todayDate
            data = data.filter {$0.valid_from.contains(todayDate)}
            
            
            
            data = data.map{
                
                let oDateFormatter = DateFormatter()
                oDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                let date = oDateFormatter.date(from: $0.valid_from)
                let resultString = oDateFormatter.string(from: date!)
                
                return Consumption(value_exc_vat: $0.value_exc_vat,
                                   value_inc_vat: $0.value_inc_vat,
                                   valid_from: resultString,
                                   valid_to: $0.valid_from.replacingOccurrences(of: todayDate+"T", with: ""),
                                   valid_from_date: date
                )}.reversed()
        }
    }
}
