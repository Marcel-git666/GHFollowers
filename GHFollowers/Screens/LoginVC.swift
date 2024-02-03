//
//  LoginVC.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 02.02.2024.
//

import UIKit

class LoginVC: UIViewController {
    
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 24)
    let userNameTextField = GFTextField()
    let secretTextField = GFTextField()
    let loginButton = GFButton(color: .systemGreen, title: "Log In", systemImageName: "key.horizontal")
    
    var isUsernameEntered: Bool { !userNameTextField.text!.isEmpty }
    var isSecretEntered: Bool { !secretTextField.text!.isEmpty }

    let padding: CGFloat = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(titleLabel, userNameTextField, secretTextField, loginButton)
        configureTitleLabel()
        configureUserNameTextField()
        configureSecretTextField()
        configureLoginButton()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Enter your credentials for GitHub"
        titleLabel.textColor = .label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureUserNameTextField() {
        userNameTextField.placeholder = "Enter your login to GitHub"
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSecretTextField() {
        secretTextField.placeholder = "Enter your password or token"
        NSLayoutConstraint.activate([
            secretTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50),
            secretTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            secretTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            secretTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureLoginButton() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: secretTextField.bottomAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


}

#Preview {
    LoginVC()
}
