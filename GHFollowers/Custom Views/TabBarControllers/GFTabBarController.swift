//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 24.01.2024.
//

import UIKit

class GFTabBarController: UITabBarController {

    let oAuthService: OAuthService
    let tokenRepository: TokenRepository

    init(oAuthService: OAuthService, tokenRepository: TokenRepository) {
        self.oAuthService = oAuthService
        self.tokenRepository = tokenRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavoritesNC(), createLoginNC()]
    }

    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC(tokenRepository: tokenRepository)
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }

    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoriteListVC(tokenRepository: tokenRepository)
        favoritesListVC.title = "Favourites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesListVC)
    }

    func createLoginNC() -> UINavigationController {
        let loginVC = LoginVC(oAuthService: oAuthService, tokenRepository: tokenRepository)
        loginVC.title = "Login"
        loginVC.tabBarItem = UITabBarItem(title: "Login", image: SFSymbols.login, tag: 2)
        return UINavigationController(rootViewController: loginVC)
    }
}
