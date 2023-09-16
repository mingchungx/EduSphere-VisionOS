//
//  LearnViewModel.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import Foundation
import Alamofire
import SwiftUI

@MainActor
final class LearnViewModel: ObservableObject {
    @Published var mod3D: Mod3D = Mod3D(
        name: "PLACEHOLDER",
        url: "https://storage.googleapis.com/edusphere/low_poly/arcade_low.usdz"
    )
    
    @Published var choices: [Choice] = []
    
    private let start = 1
    private let end = 177
    
    func fetchRandomMod3D() async throws {
        let id = Int.random(in: start...end)
        let parameters: Parameters = ["id": id]
        debugPrint("Fetching id: \(id)")
        
        // Get the Mod3D from CockroachDB backend
        // Make GET request
        AF.request("http://127.0.0.1:8000/api/item-from-id", parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                // Process data on success
                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let jsonDict = json as? [String: Any] {
                    let name = jsonDict["name"] as? String
                    let url = jsonDict["url"] as? String

                    // Access and use the extracted components as needed
                    print("Name:", name ?? "")
                    print("URL:", url ?? "")
                    
                    self.mod3D = Mod3D(name: name!, url: url!)
                    
                                        
                }
            case .failure(let error):
                self.mod3D = Mod3D(
                    name: "PLACEHOLDER",
                    url: "https://storage.googleapis.com/edusphere/low_poly/arcade_low.usdz"
                )
            }
        }
    }
    
    func fetchChoices() async throws {
        // Fetch choices from API
        
        
        self.choices = [
            Choice(text: "PLACEHOLDER 1", correct: false, color: Color.red),
            Choice(text: "PLACEHOLDER 2", correct: true, color: Color.blue),
            Choice(text: "PLACEHOLDER 3", correct: false, color: Color.yellow)
        ]
    }
}
