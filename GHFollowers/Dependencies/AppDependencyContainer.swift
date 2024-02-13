//
//  AppDependencyContainer.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 09.02.2024.
//

import UIKit

class AppDependencyContainer {
    let deepLinkHandler = DeepLinkHandler()

    func makeMainViewController() -> UIViewController {
        let redirectUri = URL(string: GitHub.redirectURI)!
        let oAuthConfig = OAuthConfig(authorizationUrl: URL(string: "https://github.com/login/oauth/authorize")!,
                                      tokenUrl: URL(string: "https://github.com/login/oauth/access_token")!,
                                      clientId: GitHub.clientID,
                                      clientSecret: GitHub.clientSecret,
                                      redirectUri: redirectUri,
                                      scopes: ["repo", "user"])
        let oAuthClient = RemoteOAuthClient(config: oAuthConfig, httpClient: HTTPClient())
        let tokenRepository = CoreDataTokenRepository()
        let oAuthService = OAuthService(oauthClient: oAuthClient, tokenRepository: tokenRepository)
        let deepLinkCallback: (DeepLink) -> Void = { deepLink in
            if case .oAuth(let url) = deepLink {
                oAuthService.exchangeCodeForToken(url: url)
            }
        }
        deepLinkHandler.addCallback(deepLinkCallback, forDeepLink: DeepLink(url: redirectUri)!)
        let tabbarController = GFTabBarController(oAuthService: oAuthService, tokenRepository: tokenRepository)
        let navigationController = UINavigationController(rootViewController: tabbarController)
        return navigationController
    }
}
