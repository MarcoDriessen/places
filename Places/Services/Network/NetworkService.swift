//
//  APIService.swift
//  Places
//
//  Created by Marco Driessen on 18/05/2024.
//

import Foundation

enum NetworkServiceError: Error {
  case decodingError
  case invalidResponse
}

protocol NetworkService {
  var decoder: JSONDecoder { get }
  var urlSession: URLSession { get }
  func fetch<T: Decodable>(from url : URL) async throws -> T
}
