//
//  File.swift
//  Countries
//
//  Created by Damian Ivanov on 6.01.24.
//

import Foundation

enum CFError: String, Error {

    case invalidURL = "Invalid URL."
    case unableToComplete = "Unable to complete the request. Check your network connection."
    case invalidResponse = "Invalid response from the server. Try again."
    case invalidData = "The data response from the server was invalid."
    case unableToFavorite = "There was an error favoriting this country."
    case alreadyFavorited = "You already favorited this country."
    case invalidClientKey = "Invalid or missing client key for Unsplash."
    case invalidCountryName = "Invalid counntry name."
}
