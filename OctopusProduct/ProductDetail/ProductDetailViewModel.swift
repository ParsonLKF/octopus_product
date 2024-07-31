//
//  ProductDetailViewModel.swift
//  OctopusProduct
//
//  Created by Parson Lam on 25/4/2024.
//

import Foundation

 @MainActor class ProductDetailViewModel: ObservableObject {
    var productDetail: ProductDetail?
    
    @Published var tariffs: [DebitDetail] = []
    
    func fetch(productCode: String) {
        Task {
            self.productDetail = try await NetworkManager.shareInstance().getProductDetail(productCode: productCode)
            tariffs = []
            if let tariffs1 = self.productDetail?.single_register_electricity_tariffs?._A?.direct_debit_monthly {
                tariffs.append(tariffs1)
            }
            if let tariffs1 = self.productDetail?.single_register_electricity_tariffs?._A?.direct_debit_quarterly {
                tariffs.append(tariffs1)
            }
            if let tariffs1 = self.productDetail?.single_register_electricity_tariffs?._B?.direct_debit_monthly {
                tariffs.append(tariffs1)
            }
            if let tariffs1 = self.productDetail?.single_register_electricity_tariffs?._B?.direct_debit_quarterly {
                tariffs.append(tariffs1)
            }
            
            if let tariffs2 = self.productDetail?.dual_register_electricity_tariffs?._A?.direct_debit_monthly {
                tariffs.append(tariffs2)
            }
            if let tariffs2 = self.productDetail?.dual_register_electricity_tariffs?._A?.direct_debit_quarterly {
                tariffs.append(tariffs2)
            }
            if let tariffs2 = self.productDetail?.dual_register_electricity_tariffs?._B?.direct_debit_monthly {
                tariffs.append(tariffs2)
            }
            if let tariffs2 = self.productDetail?.dual_register_electricity_tariffs?._B?.direct_debit_quarterly {
                tariffs.append(tariffs2)
            }
            
            if let tariffs3 = self.productDetail?.single_register_gas_tariffs?._A?.direct_debit_monthly {
                tariffs.append(tariffs3)
            }
            if let tariffs3 = self.productDetail?.single_register_gas_tariffs?._A?.direct_debit_quarterly {
                tariffs.append(tariffs3)
            }
            if let tariffs3 = self.productDetail?.single_register_gas_tariffs?._B?.direct_debit_monthly {
                tariffs.append(tariffs3)
            }
            if let tariffs3 = self.productDetail?.single_register_gas_tariffs?._B?.direct_debit_quarterly {
                tariffs.append(tariffs3)
            }
        }
    }
}



