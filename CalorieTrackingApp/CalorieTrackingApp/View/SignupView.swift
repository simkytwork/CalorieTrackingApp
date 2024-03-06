//
//  SignupView.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 06/03/2024.
//

import UIKit

class SignupView: UIView {
    private let containerView = UIView()
    private let emailTextField = UITextField()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let signupButton = UIButton(type: .system)
    var onSignupButtonTapped: ((_ email: String, _ username: String, _ password: String, _ confirmPassword: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupTextFields()
        setupSignupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextFields() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.returnKeyType = .done
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.returnKeyType = .done
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.returnKeyType = .done
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.returnKeyType = .done
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(emailTextField)
        containerView.addSubview(usernameTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(confirmPasswordTextField)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            usernameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    func setTextFieldDelegates(_ delegate: UITextFieldDelegate) {
        emailTextField.delegate = delegate
        usernameTextField.delegate = delegate
        passwordTextField.delegate = delegate
        confirmPasswordTextField.delegate = delegate
    }
    
    private func setupSignupButton() {
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signupButton.backgroundColor = UIColor.systemGreen
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.layer.cornerRadius = 5
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(signupButton)
        
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            signupButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc private func signupButtonTapped() {
        let email = emailTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""

        onSignupButtonTapped?(email, username, password, confirmPassword)
    }
}
