//
//  URLComposable.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import Foundation

protocol URLComposable {
    var url: URL? { get }
    func addQueryItem(name: String, value: String) -> Self
}
