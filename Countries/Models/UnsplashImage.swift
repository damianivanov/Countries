//
//  UnsplashImage.swift
//  Countries
//
//  Created by Damian Ivanov on 9.01.24.
//

import UIKit

struct UnsplashImage: Decodable {
    var id: String
    var urls: UnsplashURLs
}

struct UnsplashURLs: Decodable {
    var regular: String
    enum CodingKeys: CodingKey {
        case regular
    }
}

struct UnsplashResponse: Decodable {
    var results: [UnsplashImage]
    enum CodingKeys: CodingKey {
        case results
    }
}
