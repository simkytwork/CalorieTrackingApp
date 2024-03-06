//
//  AuthManager.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 06/03/2024.
//

import UIKit

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func register(email: String, username: String, password: String, completion: @escaping () -> Void,
                          onFailure: @escaping (String) -> Void) {
        NetworkManager.register(username: username, email: email, password: password, completion: {
            DispatchQueue.main.async {
                completion()
            }
        }, onFailure: onFailure)
    }
    
    func login(username: String, password: String, completion: @escaping () -> Void,
                          onFailure: @escaping (String) -> Void) {
        NetworkManager.login(username: username, password: password, completion: {
            DispatchQueue.main.async {
                self.saveLoginState(isLoggedIn: true, username: username)
                completion()
            }
        }, onFailure: onFailure)
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func currentUsername() -> String? {
        return UserDefaults.standard.string(forKey: "username")
    }

    func saveLoginState(isLoggedIn: Bool, username: String) {
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        UserDefaults.standard.set(username, forKey: "username")
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "username")
    }
}
