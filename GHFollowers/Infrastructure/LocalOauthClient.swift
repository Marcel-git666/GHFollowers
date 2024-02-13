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
        let urlString =
        """
            https://github.com/login/oauth/authorize?client_id=\(GitHub.clientID)&redirect_uri=
            \(GitHub.redirectURI)&s&scopes=repo,user&state=\(state)
        """
        return URL(string: urlString)!
    }
}
