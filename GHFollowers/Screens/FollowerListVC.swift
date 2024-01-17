//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 10.01.2024.
//

import UIKit

class FollowerListVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollower(for: username, page: 1) { result in
            switch result {
            case .success(let followers): print(followers)
            case .failure(let error): self.presentGFAlertOnMainThread(title: "Something bad happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
