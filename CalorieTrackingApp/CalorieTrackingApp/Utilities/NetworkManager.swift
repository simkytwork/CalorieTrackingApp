//
//  NetworkManager.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 04/03/2024.
//

import Foundation

class NetworkManager {
    static func fetchFoodItems(for searchString: String, completion: @escaping ([EdamamItem]?) -> Void) {
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
