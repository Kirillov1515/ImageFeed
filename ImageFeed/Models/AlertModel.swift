//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Macbook on 17.02.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
