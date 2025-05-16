//
//  NetworkManager.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 28.04.25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "com.app.network", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            
            do {
                let productResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
                completion(.success(productResponse.products))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                
                completion(.failure(error))
            }
        } .resume()
    }
}
