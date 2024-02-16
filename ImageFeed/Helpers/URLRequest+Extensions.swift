//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Macbook on 16.02.2024.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL?) -> URLRequest? {
        guard
            let baseURL = baseURL ?? URL(string: ApiConstants.unsplashApiBaseURLString),
            let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Failed to create URL with path: \(path)")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
