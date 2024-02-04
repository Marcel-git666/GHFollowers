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
    let secretTextField = GFSecretTextField()
    let loginButton = GFButton(color: .systemGreen, title: "Log In", systemImageName: "key.horizontal")
    
    var isUsernameEntered: Bool { !userNameTextField.text!.isEmpty }
    var isSecretEntered: Bool { !secretTextField.text!.isEmpty }
    var isLoggedIn: Bool = false

    let padding: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(titleLabel, userNameTextField, secretTextField, loginButton)
        configureTitleLabel()
        configureUserNameTextField()
        configureSecretTextField()
        configureLoginButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        secretTextField.text = ""
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushSearchVC() {
        
        guard isUsernameEntered && isSecretEntered else {
            presentGFAlert(title: "Empty Username or password", message: "Please enter  username and paswword, we need to log you in 🤷‍♂️", buttonTitle: "OK")
            return
        }
        
        userNameTextField.resignFirstResponder()
        secretTextField.resignFirstResponder()
        
        
        isLoggedIn = true
        let searchVC = SearchVC(isLoggedIn: isLoggedIn)
        
        navigationController?.pushViewController(searchVC, animated: true)
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
        userNameTextField.delegate = self
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSecretTextField() {
        secretTextField.placeholder = "Enter your password or token"
        secretTextField.delegate = self
        NSLayoutConstraint.activate([
            secretTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50),
            secretTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            secretTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            secretTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(pushSearchVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: secretTextField.bottomAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushSearchVC()
        return true
    }
}

#Preview {
    LoginVC()
}
