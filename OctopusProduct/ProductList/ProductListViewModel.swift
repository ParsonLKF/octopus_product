//
//  ProductListViewModel.swift
//  OctopusProduct
//
//  Created by Parson Lam on 24/4/2024.
//

import Foundation

@MainActor final class ProductListViewModel: ObservableObject{
    
    @Published var products : [Product] = []
    @Published var isShownDetail = false
    
    var product : Product?
    var debit : DebitDetail?
    
    init() {
        if let data = BookmarkManager.shareInstance().getProduct() {
            isShownDetail = true
            
            self.product = data.product
            self.debit = data.tariff
        }
    }
    
    func fetch() {
        Task {
            do {
                self.products = try await NetworkManager.shareInstance().getProduct()
            } catch {
                
            }
        }
    }
}
