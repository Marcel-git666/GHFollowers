//
//  InMemoryTokenRepository.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 11.02.2024.
//

import Foundation

class InMemoryTokenRepository: TokenRepository {
    private var tokenBag: TokenBag?
    
    func getToken() -> TokenBag? { tokenBag }
    
    func setToken(tokenBag: TokenBag?) throws { self.tokenBag = tokenBag }
    
    func resetToken() throws { tokenBag = nil }
}
