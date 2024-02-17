//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Macbook on 16.02.2024.
//

import Foundation

final class OAuth2TokenStorage {    
    private enum Keys: String {
        case token
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
