//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Macbook on 16.02.2024.
//

import Foundation

//MARK: - Enum NetworkError
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

//MARK: - Extension URLSession
extension URLSession {
    func fetchData(for request: URLRequest, completion: @escaping (Result<Data,Error>) -> Void) -> URLSessionTask {
        let completionOnMainQueue: (Result<Data,Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    completionOnMainQueue(.success(data))
                } else {
                    completionOnMainQueue(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                completionOnMainQueue(.failure(NetworkError.urlRequestError(error)))
            } else {
                completionOnMainQueue(.failure(NetworkError.urlSessionError))
            }
        }
        
        task.resume()
        return task
    }
}
