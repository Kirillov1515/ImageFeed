//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Macbook on 17.02.2024.
//

import Foundation

final class ProfileImageService {
    //MARK: - Variables
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: Keys.notificationName)
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    private struct Keys {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let httpMethodGet = "GET"
        static let notificationName = "ProfileImageProviderDidChange"
        static let paramNameURL = "URL"
    }
    
    //MARK: - Initialization
    private init() {}
    
    //MARK: - Functions
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        if avatarURL != nil { return }
        task?.cancel()
        
        var requestImage = profileImageURLRequest(userName: username)
        requestImage?.addValue("\(Keys.bearer) \(token)", forHTTPHeaderField: Keys.authorization)
        
        guard let requestImage = requestImage else { return }
        
        let task = urlSession.objectTask(for: requestImage) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let avatarURL = body.profileImage?.small
                    guard let avatarURL = avatarURL else { return }
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                    object: self,
                                                    userInfo: [Keys.paramNameURL: avatarURL])
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.avatarURL = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}

//MARK: - Private functions
private extension ProfileImageService {
    func profileImageURLRequest(userName: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/users/\(userName)",
            httpMethod: Keys.httpMethodGet, 
            baseURL: URL(string: ApiConstants.unsplashApiBaseURLString)
        )
    }
}
