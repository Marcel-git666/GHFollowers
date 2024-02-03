//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 24.01.2024.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavoritesNC(), createLoginNC()]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoriteListVC()
        favoritesListVC.title = "Favourites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesListVC)
    }
    
    func createLoginNC() -> UINavigationController {
        let loginVC = LoginVC()
        loginVC.title = "Login"
        loginVC.tabBarItem = UITabBarItem(title: "Login", image: SFSymbols.login, tag: 2)
        return UINavigationController(rootViewController: loginVC)
    }
}
