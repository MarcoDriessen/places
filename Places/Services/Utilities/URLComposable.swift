//
//  URLComposable.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import Foundation

protocol URLComposable {
    var url: URL? { get }
    func setScheme(_ scheme: String) -> Self
    func setHost(_ host: String) -> Self
    func setPath(_ path: String) -> Self
    func addQueryItem(name: String, value: String?) -> Self
}
