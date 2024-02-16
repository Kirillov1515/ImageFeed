//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Macbook on 16.02.2024.
//

import Foundation

final class OAuth2Service {
    //MARK: - Variables
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    //MARK: - Public methods
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = authTokenRequest(code: code) else { return }
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    self.authToken = body.accessToken
                    completion(.success(body.accessToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

//MARK: - Private methods
private extension OAuth2Service {
    func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody,Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.fetchData(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    func authTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: ApiConstants.unsplashBaseURLString) else { preconditionFailure("No url") }
        return URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(ApiConstants.accessKey)"
            + "&&client_secret=\(ApiConstants.secretKey)"
            + "&&redirect_uri=\(ApiConstants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: url
        )
    }
}
