//
//  CoreDataTokenRepository.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 13.02.2024.
//

import Foundation

class CoreDataTokenRepository: TokenRepository {

    func getToken() -> TokenBag? {
        guard let tokenData = PersistenceManager.retrieveToken() else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let tokenBag = try decoder.decode(TokenBag.self, from: tokenData)
            return tokenBag
        } catch {
            print("Error decoding token: \(error)")
            return nil
        }
    }

    func setToken(tokenBag: TokenBag?) throws {
        guard let tokenBag = tokenBag else {
            try PersistenceManager.removeToken()
            return
        }

        do {
            let encoder = JSONEncoder()
            let tokenData = try encoder.encode(tokenBag)
            try PersistenceManager.saveToken(tokenData)
        } catch {
            throw GFError.unableToSetToken
        }
    }

    func resetToken() throws {
        try PersistenceManager.removeToken()
    }
}
