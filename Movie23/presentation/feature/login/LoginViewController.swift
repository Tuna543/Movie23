//
//  LoginViewController.swift
//  Movie23
//
//  Created by BS00880 on 24/6/24.
//

import UIKit

class LoginViewController: UIViewController {
//    private let headerView = HeaderView(title: "Welcome Back", subTitle: "Sign in to your account")
    private let imageView = UIImageView(image: UIImage(named: "loginBackgroud"))
    private let headerView = HeaderView(title: LocalizedStringKey.welcomeBack.localized(), subTitle: nil)
    private let subtitleHeaderView = HeaderView(title: nil, subTitle: LocalizedStringKey.pleaseSignInToYourAccount.localized() /*"Sign in to your account"*/)
    
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: LocalizedStringKey.signIn.localized() /*"Sign In"*/, hasBackground: true, fontSize: .big)
//    private let signInWithGoogle = CustomButton(title: "Sign In with Google", hasBackground: false, fontSize: .big, titleColor: .darkText)
    private let newUser = CustomButton(title: LocalizedStringKey.createNewAccount.localized() /*"Don't have an account? Create one"*/, fontSize: .medium, titleColor: .white)
    
    let authenticationManager = DiModule.shared.resolve(AuthenticationManager.self)!
    
//    private let watchViewModel = WatchListViewModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUser.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(imageView)
        self.view.addSubview(headerView)
        self.view.addSubview(subtitleHeaderView)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signInButton)
//        self.view.addSubview(signInWithGoogle)
        self.view.addSubview(newUser)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        subtitleHeaderView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
//        signInWithGoogle.translatesAutoresizingMaskIntoConstraints = false
        newUser.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            self.emailField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: newUser.topAnchor, constant: -80),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
     
//            self.signInWithGoogle.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
//            self.signInWithGoogle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            self.signInWithGoogle.heightAnchor.constraint(equalToConstant: 55),
//            self.signInWithGoogle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
//            
            self.newUser.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90),
            self.newUser.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.newUser.heightAnchor.constraint(equalToConstant: 55),
            self.newUser.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    @objc private func didTapSignIn() {
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        Task {
            try await authenticationManager.signIn(email: email, password: password)
            print("login called")
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                await sceneDelegate.checkSignInUser()
                print("into scene delegate")
            }
        }
    }
    
    @objc private func didTapNewUser() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
