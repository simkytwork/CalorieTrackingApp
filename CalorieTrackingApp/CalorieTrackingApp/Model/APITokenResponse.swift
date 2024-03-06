//
//  APITokenResponse.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 06/03/2024.
//

import Foundation

struct TokenResponse: Codable {
    let access_token: String
    let refresh_token: String
}
