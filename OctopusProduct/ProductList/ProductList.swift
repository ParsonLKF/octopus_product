//
//  ContentView.swift
//  OctopusProduct
//
//  Created by Parson Lam on 24/4/2024.
//

import SwiftUI

struct ProductList: View {
    
    @StateObject var viewModel = ProductListViewModel()
    
    var body: some View {
        
        List(viewModel.products, id: \.code) { product in
            NavigationLink(destination: ProductDetailView(product: product)) {
                Text("\(product.display_name) \(product.full_name)")
            }
        }
        .navigationTitle("Product Selection")
        .task {
            viewModel.fetch()
        }.fullScreenCover(isPresented: $viewModel.isShownDetail) {
            let view = ConsumptionView(fromMain: $viewModel.isShownDetail, productDetail: viewModel.product!, debitDetail: viewModel.debit!)
            return view
        }
    }
}

#Preview {
    ProductList()
}
