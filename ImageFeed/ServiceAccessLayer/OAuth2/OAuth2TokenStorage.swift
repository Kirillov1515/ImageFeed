//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Macbook on 16.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
