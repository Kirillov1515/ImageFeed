//
//  Constants.swift
//  ImageFeed
//
//  Created by Macbook on 15.02.2024.
//

import Foundation

enum ApiConstants {
    static let accessKey = "3f5yOdJjNdl9Qcxvn0lJ7NHaioOSIRJH4380o1w2guA"
    static let secretKey = "CJTV0fxTgq__x4mnqky3quvZk-zrLoiUWqQYyi0IOYM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashBaseURLString = "https://unsplash.com"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashApiBaseURLString = "https://api.unsplash.com"
}

//let defaultBaseURL = URL(string: "https://api.unsplash.com")!
