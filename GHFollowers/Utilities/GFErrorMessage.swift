//
//  GFErrorMessage.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 13.01.2024.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created invalid request, please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server, please try again."
    case invalidData = "The data received from the server was invalid. Please try again later."
    case unableToFavorite = "There was an error favoriting the user. Please trz again."
    case alreadInFavorites = "You have already favorited this user. You must love them."
}
