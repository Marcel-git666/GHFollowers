//
//  FavouriteListVC.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 08.01.2024.
//

import UIKit

class FavoriteListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        PersistanceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something is wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    


}
