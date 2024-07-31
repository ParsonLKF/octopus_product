//
//  ProductDetail.swift
//  OctopusProduct
//
//  Created by Parson Lam on 25/4/2024.
//

import SwiftUI

struct ProductDetailView: View {
    
    var product: Product
    @StateObject var viewModel: ProductDetailViewModel = ProductDetailViewModel()
    
    var body: some View {
            
        List(viewModel.tariffs, id: \.code) {data in
            NavigationLink(destination: ConsumptionView(fromMain:.constant(false), productDetail: product, debitDetail: data)) {
                Text(data.code)
            }
            
        }.task {
            viewModel.fetch(productCode: product.code)
        }.navigationTitle("Product Detail")
    }
}

#Preview {
    ProductDetailView(product: Product(code: "", full_name: "", display_name: "", description: ""))
}
