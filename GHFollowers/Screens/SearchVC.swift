//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 08.01.2024.
//

import UIKit

class SearchVC: UIViewController {

    let tokenRepository: TokenRepository
    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let callToActionButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
    let loginLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    
    var isUsernameEntered: Bool { !userNameTextField.text!.isEmpty }
    var isLoggedIn: Bool = false
    
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, userNameTextField, callToActionButton, loginLabel)
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        configureLoginLabel()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC() {
        
        guard isUsernameEntered else {
            presentGFAlert(title: "Empty Username", message: "Please enter a username, we need to know who to look for 🤷‍♂️", buttonTitle: "OK")
            return
        }
        
        userNameTextField.resignFirstResponder()
        
        let followerListVC = FollowerListVC(username: userNameTextField.text!, tokenRepository: tokenRepository)
        
        navigationController?.pushViewController(followerListVC, animated: true)
    }

    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topContraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topContraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        userNameTextField.delegate = self
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureLoginLabel() {
        if let _ = tokenRepository.getToken() {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        loginLabel.text = isLoggedIn ? "Logged in" : "Not logged in"
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

#Preview {
    SearchVC(tokenRepository: InMemoryTokenRepository())
}
