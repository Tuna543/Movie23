//
//  RegisterViewController.swift
//  Movie23
//
//  Created by BS00880 on 24/6/24.
//

import UIKit

class RegisterViewController: UIViewController {
    private let imageView = UIImageView(image: UIImage(named: "registrationBackground"))
    private let headerView = HeaderView(title: LocalizedStringKey.welcome.localized(), subTitle: nil)
    private let subtitleHeaderView = HeaderView(title: nil, subTitle: LocalizedStringKey.createNewAccount.localized())
    private let userNameField = CustomTextField(fieldType: .username)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    private let signUp = CustomButton(title: LocalizedStringKey.createNewAccount.localized() /*"Create an account"*/, hasBackground: true, fontSize: .big)
    private let oldUser = CustomButton(title: LocalizedStringKey.signIn.localized() /*/"Already have an account? Sign In"*/, fontSize: .medium, titleColor: .white)
    let authenticationManager = DiModule.shared.resolve(AuthenticationManager.self)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.signUp.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.oldUser.addTarget(self, action: #selector(didTapAlreadyHaveAnAccount), for: .touchUpInside)
    }
    
    private func setUpUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(imageView)
        self.view.addSubview(headerView)
        self.view.addSubview(subtitleHeaderView)
        self.view.addSubview(userNameField)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signUp)
        self.view.addSubview(oldUser)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        subtitleHeaderView.translatesAutoresizingMaskIntoConstraints = false
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signUp.translatesAutoresizingMaskIntoConstraints = false
        oldUser.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 50),
//            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 27),
            
            self.subtitleHeaderView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 5),
//            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.subtitleHeaderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.subtitleHeaderView.heightAnchor.constraint(equalToConstant: 27),
            
            
            self.userNameField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.userNameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.userNameField.heightAnchor.constraint(equalToConstant: 55),
            self.userNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.emailField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 20),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signUp.topAnchor.constraint(equalTo: oldUser.topAnchor, constant: -80),
            self.signUp.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUp.heightAnchor.constraint(equalToConstant: 55),
            self.signUp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.oldUser.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90),
            self.oldUser.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.oldUser.heightAnchor.constraint(equalToConstant: 55),
            self.oldUser.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    @objc func didTapSignUp() {
        let userName = self.userNameField.text ?? ""
        let email = self.emailField.text ?? ""
        let password = self.passwordField.text ?? ""
        Task {
            try await authenticationManager.createUser(userName: userName, email: email, password: password)
            print("create account called")
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                await sceneDelegate.checkSignInUser()
                print("into scene delegate")
            }
        }
    }
    
    @objc private func didTapAlreadyHaveAnAccount() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
