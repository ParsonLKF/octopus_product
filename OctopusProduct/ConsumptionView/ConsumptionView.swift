//
//  ConsumptionView.swift
//  OctopusProduct
//
//  Created by Parson Lam on 30/4/2024.
//

import Charts
import SwiftUI

struct ConsumptionView: View {
    
    @Binding var fromMain : Bool
    var productDetail : Product
    var debitDetail : DebitDetail
    @StateObject var viewModel = ConsumptionViewModel()
    
    
    var body: some View {
        
        if fromMain {
            
            HStack {
                Spacer()
                
                Button {
                    viewModel.bookmark()
                } label: {
                    Image(systemName: viewModel.isBookmark ? "bookmark.fill" : "bookmark")
                }
                
                Button {
                    fromMain.toggle()
                } label: {
                    Image(systemName: "xmark")
                }.padding()
            }
            
        }
        
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text("Product Name : \(productDetail.display_name)")
                    .font(Font.system(.headline))
                    .padding(.leading,20)
                    .padding(.top,20)
                    .padding(.bottom,10)
                Text("Product Code : \(productDetail.code)")
                    .font(Font.system(.headline))
                    .padding(.leading,20)
                    .padding(.bottom,10)
                Text("Date : \(viewModel.dateString)")
                    .font(Font.system(.headline))
                    .padding(.leading,20)
                    .padding(.bottom,10)

                
                    Chart {
                        ForEach(viewModel.data, id: \.valid_from) { data in
                            BarMark(
                                x: .value("Time", data.valid_from_date ?? Date()),
                                y: .value("Cost", data.value_inc_vat)
                            ).annotation {
                                Text(String(format: "%.2fp", data.value_inc_vat)).font(Font.system(size: 7))
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height/4)
                    .chartScrollableAxes(.horizontal)
                    .scrollIndicators(.hidden)
//                }
                .padding()
                Spacer()
            }
        }
        .toolbar {
            Button {
                viewModel.bookmark()
            } label: {
                Image(systemName: viewModel.isBookmark ? "bookmark.fill" : "bookmark")
            }
        }
        .navigationTitle("Charge Detail")
        .task {
            viewModel.fetch(product_code: productDetail.code, tariff_code: debitDetail.code)
        }
        .onAppear() {
            viewModel.setData(product: productDetail, debit: debitDetail)
        }
    }
}

#Preview {
    ConsumptionView(fromMain: .constant(false), productDetail: Product(code: "", full_name: "", display_name: "", description: ""), debitDetail: DebitDetail(code: ""))
}
