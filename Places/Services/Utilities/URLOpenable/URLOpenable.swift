//
//  URLOpenable.swift
//  Places
//
//  Created by Marco Driessen on 19/05/2024.
//

import Foundation
import UIKit

protocol URLOpenable {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: URLOpenable {}

