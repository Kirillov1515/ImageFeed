//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Macbook on 16.02.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    //MARK: - Variables
//    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var alertPresenter: AlertPresenterProtocol?
    private var authViewController: AuthViewController?
    
    private struct Keys {
        static let main = "Main"
        static let authViewControllerID = "AuthViewController"
    }
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "launchScreen"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    //MARK: - Functions
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showAuthenticationScreenSegueIdentifier {
//            guard
//                let navigationController = segue.destination as? UINavigationController,
//                let viewController = navigationController.viewControllers[0] as? AuthViewController
//            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
//            viewController.delegate = self
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
}

//MARK: - Private Methods
private extension SplashViewController {
    func setupViews() {
        addViews()
        setupConstraints()
    }
    
    func addViews() {
        view.addSubview(splashImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func checkAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showErrorAlert()
                break
            }
        }
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        authViewController = storyboard.instantiateViewController(withIdentifier: Keys.authViewControllerID) as? AuthViewController
        authViewController?.delegate = self
        guard let authViewController = authViewController else { return }
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showErrorAlert(message: "Не удалось войти в систему")
                break
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                profileImageService.fetchProfileImageURL(
                    token: token,
                    username: data.username
                ){ _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showErrorAlert()
                break
            }
        }
    }
    
    func showErrorAlert(message: String = "Не удалось войти в систему") {
        let alert = AlertModel(title: "Что-то пошло не так(",
                               message: message,
                               buttonText: "Ок",
                               completion: { [weak self] in
            guard let self = self else { return }
            oauth2TokenStorage.token = nil
        })
        let topController = UIApplication.topViewController()
        if let topController = topController {
            alertPresenter = AlertPresenter(delagate: topController as? AlertPresenterDelegate)
        } else {
            alertPresenter = AlertPresenter(delagate: self)
        }
        
        alertPresenter?.show(alertModel: alert)
    }
}

//MARK: - AlertPresenterDelagate
extension SplashViewController: AlertPresenterDelegate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }

//    private func fetchOAuthToken(_ code: String) {
//        oauth2Service.fetchOAuthToken(code) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                self.switchToTabBarController()
//                UIBlockingProgressHUD.dismiss()
//            case .failure:
//                UIBlockingProgressHUD.dismiss()
//                break
//            }
//        }
//    }
}
