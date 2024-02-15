//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Macbook on 15.02.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    //MARK: - Variables
    let showWebViewSegueIdentifire = "ShowWebView"
    
    //MARK: - Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifire {
            guard let webViewViewController = segue.destination as? WebViewViewController else { fatalError("Failed to prepare for \(showWebViewSegueIdentifire)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
