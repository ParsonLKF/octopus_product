//
//  NetworkManager.swift
//  OctopusProduct
//
//  Created by Parson Lam on 24/4/2024.
//

import Foundation

enum APIError : Error {
    
    case error
}

class NetworkManager {
    
    private let BaseURL = "https://api.octopus.energy"
    
    static private let networkMgr = NetworkManager()
    static func shareInstance() -> NetworkManager {
        return networkMgr
    }
    
    func getProduct() async throws -> [Product]{
        
        do {            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: BaseURL+"/v1/products/")!))
            let result = try JSONDecoder().decode(ProductBaseResponse.self, from: data)
            return result.results
        } catch {
            print(error)
        }
        throw APIError.error
    }
    
    func getProductDetail(productCode: String) async throws -> ProductDetail {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: BaseURL+"/v1/products/\(productCode)")!))
            let result = try JSONDecoder().decode(ProductDetail.self, from: data)
            return result
        } catch {
            print(error)
        }
        throw APIError.error
    }
    
    func getConsumption(product_code: String, tariff_code: String) async throws -> [Consumption] {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: BaseURL+"/v1/products/\(product_code)/electricity-tariffs/\(tariff_code)/standard-unit-rates/")!))
            let result = try JSONDecoder().decode(ConsumptionResult.self, from: data)
            return result.results
        } catch {
            print(error)
        }
        throw APIError.error
    }
}

struct ConsumptionResult : Decodable {
    var count : Int?
    var results : [Consumption]
}

struct Consumption : Decodable {
    var value_exc_vat : Double
    var value_inc_vat : Double
    var valid_from : String
    var valid_to : String
    
    var valid_from_date : Date?
}

struct ProductBaseResponse : Decodable {
    var count: Int
//    var previous: String
    var results: [Product]
}


struct Product : Decodable {
    var code: String
    var full_name: String
    var display_name: String
    var description: String
}

struct ProductDetail : Decodable {
    var code: String
    var full_name: String
    var single_register_electricity_tariffs: Tariffs?
    var dual_register_electricity_tariffs: Tariffs?
    var single_register_gas_tariffs: Tariffs?
}

struct Tariffs: Decodable{
    var _A: TariffsDetail?
    var _B: TariffsDetail?
}

struct TariffsDetail: Decodable {
    var direct_debit_monthly: DebitDetail?
    var direct_debit_quarterly: DebitDetail?
}

struct DebitDetail: Decodable {
    var code: String
}
