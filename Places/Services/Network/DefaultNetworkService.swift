//
//  DefaultNetworkService.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import Foundation

struct DefaultNetworkService: NetworkService {
    
    let decoder: JSONDecoder
    let urlSession: URLSession
    
    init(decoder: JSONDecoder = JSONDecoder(),
         urlSession: URLSession = .shared) {
        self.decoder = decoder
        self.urlSession = urlSession
    }
    
    func fetch<T>(from url: URL) async throws -> T where T: Decodable {
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidResponse
        }

        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkServiceError.decodingError
        }
    }
}
