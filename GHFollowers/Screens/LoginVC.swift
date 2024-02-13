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
    let tokenRepository: TokenRepository

    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 24)
    let loginButton = GFButton(color: .systemGreen, title: "Log In", systemImageName: "key.horizontal")
    let logoutButton = GFButton(color: .systemRed, title: "Log Out", systemImageName: "key.slash")
    let loginInfo = GFBodyLabel(textAlignment: .left)
    let padding: CGFloat = 20

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
        view.backgroundColor = .systemBackground
        view.addSubviews(titleLabel, loginButton, logoutButton, loginInfo)
        configureTitleLabel()
        configureLoginButton()
        configureLogoutButton()
        configureLoginInfo()
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

    func configureLogoutButton() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureLoginInfo() {
            if let tokenBag = tokenRepository.getToken(), !tokenBag.accessToken.isEmpty {
                self.loginInfo.text = "User is logged in with the Access Token: \(tokenBag.accessToken)"
            } else {
                self.loginInfo.text = "User is logged out."
            }
        loginInfo.numberOfLines = 0
        loginInfo.lineBreakMode = .byWordWrapping
        NSLayoutConstraint.activate([
            loginInfo.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 50),
            loginInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            loginInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loginInfo.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc func logoutButtonTapped() {
        initiateLogout()
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

    func initiateLogout() {
        do {
            try tokenRepository.resetToken()
        } catch {
            print("Error resetting token: \(error)")
        }
        self.loginInfo.text = "User is logged out."
    }

    func onAuthenticationResult(result: Result<TokenBag, Error>) {
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true) {
                switch result {
                case .success(let tokenBag):
                    do {
                        try self.tokenRepository.setToken(tokenBag: tokenBag)
                        self.loginInfo.text = "User is logged in with the Access Token: \(tokenBag.accessToken)"
                    } catch {
                        let alert = UIAlertController(title: "Token", message: tokenBag.accessToken, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }

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
    LoginVC(
        oAuthService: OAuthService(oauthClient: LocalOauthClient(),
        tokenRepository: InMemoryTokenRepository()),
        tokenRepository: InMemoryTokenRepository())
}
