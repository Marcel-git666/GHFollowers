//
//  LocalOauthClient.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 09.02.2024.
//

import Foundation

class LocalOauthClient: OAuthClient {
    
    func exchangeCodeForToken(code: String, state: String, completion: @escaping (Result<TokenBag, Error>) -> Void) {
        completion(.success(TokenBag(accessToken: "anAccessToken")))
    }
    
    func getAuthPageUrl(state: String) -> URL? {
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(GitHub.clientID)&redirect_uri=\(GitHub.redirectURI)&s&scopes=repo,user&state=\(state)"
//        let urlString = "https://codesandbox.io/s/affectionate-wind-wp72f"
        return URL(string: urlString)!
    }
}
