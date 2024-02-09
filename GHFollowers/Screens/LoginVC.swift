//
//  LoginVC.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 02.02.2024.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {
    
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 24)
    
    let loginButton = GFButton(color: .systemGreen, title: "Log In", systemImageName: "key.horizontal")
    
    
    var isLoggedIn: Bool = false
    
    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(titleLabel, loginButton)
        configureTitleLabel()
        configureLoginButton()
    }
    
    
    
    func configureTitleLabel() {
        titleLabel.text = "Log into your GitHub"
        titleLabel.textColor = .label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func loginButtonTapped() {
        initiateOAuthFlow()
    }
    
    func initiateOAuthFlow() {
        let authURLString = "https://github.com/login/oauth/authorize?client_id=\(GitHub.clientID)&scope=user%20repo&redirect_uri=\(GitHub.redirectURI)"
        guard let authURL = URL(string: authURLString) else { return }
        
        let safariVC = SFSafariViewController(url: authURL)
        safariVC.delegate = self
        present(safariVC, animated: true)
    }
    
}

extension LoginVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("SafariView did finished.")
    }
}

#Preview {
    LoginVC()
}
