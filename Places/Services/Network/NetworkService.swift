//
//  APIService.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError
}

protocol NetworkService {
    var decoder: JSONDecoder { get }
    var urlSession: URLSession { get }
    func fetch<T: Decodable>(from url : URL) async throws -> T
}
