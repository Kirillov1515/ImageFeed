//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Macbook on 17.02.2024.
//

import UIKit

final class AlertPresenter {
    private weak var delagate: AlertPresenterDelegate?
    
    init(delagate: AlertPresenterDelegate?) {
        self.delagate = delagate
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        delagate?.present(alert: alert, animated: true)
    }
}
