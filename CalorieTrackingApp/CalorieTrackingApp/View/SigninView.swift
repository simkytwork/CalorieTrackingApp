//
//  LoginView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 04/03/2024.
//

import UIKit

class SigninView: UIView {
    private let containerView = UIView()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let signupLabel = UILabel()
    var onSignupTapped: (() -> Void)?
    private let signinButton = UIButton(type: .system)
    var onSigninButtonTapped: ((_ username: String, _ password: String) -> Void)?
    
    private let welcomeLabel = UILabel()
    private let signOutButton = UIButton(type: .system)
    var onSignoutTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupTextFields()
        setupSigninButton()
        setupLoggedInUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextFields() {
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.returnKeyType = .done
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.returnKeyType = .done
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        signupLabel.text = "Don't have an account? Sign up!"
        signupLabel.textColor = .systemGray
        signupLabel.textAlignment = .center
        signupLabel.font = UIFont.systemFont(ofSize: 13)
        signupLabel.isUserInteractionEnabled = true
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(usernameTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(signupLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signupLabelTapped))
        signupLabel.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            signupLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            signupLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            signupLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    @objc private func signupLabelTapped() {
        onSignupTapped?()
    }
    
    func setTextFieldDelegates(_ delegate: UITextFieldDelegate) {
        usernameTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }
    
    private func setupSigninButton() {
        signinButton.setTitle("Sign In", for: .normal)
        signinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signinButton.backgroundColor = UIColor.systemGreen
        signinButton.setTitleColor(.white, for: .normal)
        signinButton.layer.cornerRadius = 5
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(signinButton)
        
        signinButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signinButton.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 30),
            signinButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            signinButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            signinButton.heightAnchor.constraint(equalToConstant: 50),
            signinButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc private func signinButtonTapped() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        onSigninButtonTapped?(username, password)
    }
    
    private func setupLoggedInUI() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.textAlignment = .center
        containerView.addSubview(welcomeLabel)
        
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signOutButton.backgroundColor = UIColor.systemRed
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.layer.cornerRadius = 5
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(signOutButton)
        
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            signOutButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            signOutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        welcomeLabel.isHidden = true
        signOutButton.isHidden = true
    }
    
    func updateUIForLoggedInUser(username: String? = nil, isLoggedIn: Bool) {
        let isHidden = isLoggedIn
        usernameTextField.isHidden = isHidden
        passwordTextField.isHidden = isHidden
        signinButton.isHidden = isHidden
        signupLabel.isHidden = isHidden
        
        welcomeLabel.isHidden = !isHidden
        signOutButton.isHidden = !isHidden
        
        if isLoggedIn, let username = username {
            welcomeLabel.text = "Welcome, \(username)!"
        }
    }
    
    @objc private func signOutButtonTapped() {
        onSignoutTapped?()
    }
}

