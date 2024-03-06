//
//  NetworkManager.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 04/03/2024.
//

import Foundation
import KeychainSwift

class NetworkManager {
    static func getCurrentAccessToken() -> String {
        let keychain = KeychainSwift()
        return keychain.get("accessToken") ?? ""
    }
    
    static func getCurrentRefreshToken() -> String {
        let keychain = KeychainSwift()
        return keychain.get("refreshToken") ?? ""
    }
    
    static func saveToken(accessToken: String, refreshToken: String) {
        let keychain = KeychainSwift()
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    static func clearTokens() {
        let keychain = KeychainSwift()
        keychain.delete("accessToken")
        keychain.delete("refreshToken")
    }
    
    static func register(username: String, email: String, password: String, completion: @escaping () -> (), onFailure: @escaping (String) -> ()) {
        let registerUrl = URL(string: "http://192.168.0.147:4000/api/register")!
        var request = URLRequest(url: registerUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let registrationDetails = ["name": username, "emailAddress": email, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: registrationDetails)
        } catch {
            DispatchQueue.main.async {
                onFailure("Error: \(error.localizedDescription)")
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    onFailure("Register error: \(error.localizedDescription)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    if let data = data {
                        do {
                            let responseMessage = try JSONDecoder().decode([String: String].self, from: data)
                            completion()
                        } catch {
                            print("Error decoding register response: \(error.localizedDescription)")
                        }
                    }
                } else {
                    if let data = data,
                       let errorMessage = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                        DispatchQueue.main.async {
                            onFailure(errorMessage)
                        }
                    } else {
                        DispatchQueue.main.async {
                            onFailure("Registering failed")
                        }
                    }
                }
            }
        }.resume()
    }
    
    static func login(username: String, password: String, completion: @escaping () -> (), onFailure: @escaping (String) -> ()) {
        let loginUrl = URL(string: "http://192.168.0.147:4000/api/login")!
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginDetails = ["name": username, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginDetails)
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    onFailure("Login error: \(error.localizedDescription)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                            saveToken(accessToken: tokenResponse.access_token, refreshToken: tokenResponse.refresh_token)
                            completion() // retries whichever function was passed in
                        } catch {
                            print("Error decoding login response: \(error.localizedDescription)")
                        }
                    }
                } else {
                    if let data = data,
                       let errorMessage = try? JSONDecoder().decode([String: String].self, from: data)["message"] {
                        DispatchQueue.main.async {
                            onFailure(errorMessage)
                        }
                    } else {
                        DispatchQueue.main.async {
                            onFailure("Login failed")
                        }
                    }
                }
            }
        }.resume()
    }
    
    static func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://192.168.0.147:4000/api/accessToken") else { return completion(false) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(getCurrentRefreshToken())", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error refreshing token: \(error!.localizedDescription)")
                return completion(false)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to refresh token: \(response.debugDescription)")
                return completion(false)
            }
            
            if let data = data {
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    saveToken(accessToken: tokenResponse.access_token, refreshToken: tokenResponse.refresh_token)
                    completion(true)
                } catch {
                    print("Error decoding token response: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }.resume()
    }
    
    static func fetchFoodFromEdamam(for searchString: String, completion: @escaping ([EdamamItem]?) -> Void) {
        let appID = "06013183"
        let appKey = "80a6dc6e5e4f3f993838d3ccb6c68a04"
        let urlString = "https://api.edamam.com/api/food-database/v2/parser?ingr=\(searchString)&app_id=\(appID)&app_key=\(appKey)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(EdamamResponse.self, from: data)
//                let parsedItems = response.parsed.map { $0.food }
                let hintItems = response.hints.map { $0.food }
                
//                let combinedItems = parsedItems + hintItems
                print(hintItems)
                completion(hintItems)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }
}
