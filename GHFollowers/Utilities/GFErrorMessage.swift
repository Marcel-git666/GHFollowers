//
//  GFErrorMessage.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 13.01.2024.
//

import Foundation

enum GFError: Error {
    case invalidUsername
    case unableToComplete
    case invalidResponse
    case invalidData
    case unableToFavorite
    case alreadyInFavorites
    case invalidURL
    case failedToFollowUser(username: String, statusCode: Int)
    case unableToRetrieveToken
    case unableToSetToken

    var rawValue: String {
        switch self {
        case .invalidUsername:
            return "This username created invalid request, please try again."
        case .unableToComplete:
            return "Unable to complete your request. Please check your internet connection."
        case .invalidResponse:
            return "Invalid response from the server, please try again."
        case .invalidData:
            return "The data received from the server was invalid. Please try again later."
        case .unableToFavorite:
            return "There was an error favoriting the user. Please try again."
        case .alreadyInFavorites:
            return "You have already favorited this user. You must love them."
        case .invalidURL:
            return "My URL is invalid, sorry."
        case .failedToFollowUser(let username, let statusCode):
            return "I have failed to follow \(username). Do you already follow him/her? Status code: \(statusCode)"
        case .unableToRetrieveToken:
            return "I cannot find your token."
        case .unableToSetToken:
            return "I have problem saving your token."
        }
    }
}
