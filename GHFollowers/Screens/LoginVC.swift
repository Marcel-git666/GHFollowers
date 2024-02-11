//
//  LoginVC.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 02.02.2024.
//

import UIKit
import SafariServices

class LoginVC: UIViewController {
    
    let oAuthService: OAuthService
    
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 24)
    let loginButton = GFButton(color: .systemGreen, title: "Log In", systemImageName: "key.horizontal")
    
    let padding: CGFloat = 20
    
    
    init(oAuthService: OAuthService) {
        self.oAuthService = oAuthService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(titleLabel, loginButton)
        configureTitleLabel()
        configureLoginButton()
        oAuthService.onAuthenticationResult = { [weak self] in self?.onAuthenticationResult(result: $0) }
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
        guard let url = oAuthService.getAuthPageUrl() else { return }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true, completion: nil)
    }  
    
    func onAuthenticationResult(result: Result<TokenBag, Error>) {
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true) {
                switch result {
                case .success(let tokenBag):
                    let alert = UIAlertController(title: "Token",
                                                  message: tokenBag.accessToken,
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                case .failure:
                    let alert = UIAlertController(title: "Something went wrong :(",
                                                  message: "Authentication error",
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

#Preview {
    LoginVC(oAuthService: OAuthService(oauthClient: LocalOauthClient()))
}
