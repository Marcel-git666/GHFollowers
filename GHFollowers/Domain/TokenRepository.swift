//
//  TokenRepository.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 11.02.2024.
//

import Foundation

protocol TokenRepository {
    func getToken() -> TokenBag?
    func setToken(tokenBag: TokenBag?) throws
    func resetToken() throws
}
