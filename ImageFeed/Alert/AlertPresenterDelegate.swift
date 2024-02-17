//
//  AlertPresenterDelegate.swift
//  ImageFeed
//
//  Created by Macbook on 17.02.2024.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(alert: UIAlertController, animated flag: Bool)
}
