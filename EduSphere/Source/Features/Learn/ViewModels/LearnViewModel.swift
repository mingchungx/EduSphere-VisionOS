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
    
    @Published var choices: [Choice] = [
        Choice(text: "", correct: false, color: Color.red),
        Choice(text: "", correct: false, color: Color.blue),
        Choice(text: "", correct: false, color: Color.yellow)
    ]
    
    private let start = 0
    private let end = 176
    
    func fetchRandomMod3D(src: String, dest: String) async throws {
        let endpoint = "http://127.0.0.1:8000/api/item-from-id"
        let id = Int.random(in: start...end)
        let parameters: Parameters = ["id": id]
        debugPrint("Fetching id: \(id)")
        
        // Get the Mod3D from CockroachDB backend
        // Make GET request
        AF.request(endpoint, parameters: parameters).responseData { response in
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
            
                    Task {
                        try? await self.fetchChoices(word: name ?? "PLACEHOLDER", src: src, dest: dest)
                    }
                }
            case .failure(_):
                // Ignore error case
                self.mod3D = Mod3D(
                    name: "PLACEHOLDER",
                    url: "https://storage.googleapis.com/edusphere/low_poly/arcade_low.usdz"
                )
            }
        }
    }
    
    private func fetchChoices(word: String, src: String, dest: String) async throws {
        // src is the source language, dest is the destination language
        let endpoint = "http://127.0.0.1:5000/translate"
        let randomWords = getRandomWords()
        let parameters1: Parameters = [
            "word": randomWords.0,
            "src": src,
            "dest": dest
        ]
        let parameters2: Parameters = [
            "word": randomWords.1,
            "src": src,
            "dest": dest
        ]
        
        // parameters3 is always the correct one
        let parameters3: Parameters = [
            "word": word,
            "src": src,
            "dest": dest
        ]
        
        debugPrint("Attempting to translate \(word) from \(src) to \(dest)")
        
        // Fetch choices from API
        AF.request(endpoint, parameters: parameters1).responseData { response in
            switch response.result {
            case .success(let data):
                // Process data on success
                if let string = String(data: data, encoding: .utf8) {
                    self.choices[0] = Choice(text: string.capitalized, correct: false, color: Color.red)
                }
            case .failure(_):
                // Ignore error case
                self.choices = [
                    Choice(text: "PLACEHOLDER 1", correct: false, color: Color.red),
                    Choice(text: "PLACEHOLDER 2", correct: true, color: Color.blue),
                    Choice(text: "PLACEHOLDER 3", correct: false, color: Color.yellow)
                ]
            }
        }
        
        AF.request(endpoint, parameters: parameters2).responseData { response in
            switch response.result {
            case .success(let data):
                // Process data on success
                if let string = String(data: data, encoding: .utf8) {
                    self.choices[1] = Choice(text: string.capitalized, correct: false, color: Color.blue)
                }
            case .failure(_):
                // Ignore error case
                self.choices = [
                    Choice(text: "PLACEHOLDER 1", correct: false, color: Color.red),
                    Choice(text: "PLACEHOLDER 2", correct: true, color: Color.blue),
                    Choice(text: "PLACEHOLDER 3", correct: false, color: Color.yellow)
                ]
            }
        }
        
        AF.request(endpoint, parameters: parameters3).responseData { response in
            switch response.result {
            case .success(let data):
                // Process data on success
                if let string = String(data: data, encoding: .utf8) {
                    self.choices[2] = Choice(text: string.capitalized, correct: true, color: Color.yellow)
                }
            case .failure(_):
                // Ignore error case
                self.choices = [
                    Choice(text: "PLACEHOLDER 1", correct: false, color: Color.red),
                    Choice(text: "PLACEHOLDER 2", correct: true, color: Color.blue),
                    Choice(text: "PLACEHOLDER 3", correct: false, color: Color.yellow)
                ]
            }
        }
    }
    
    private func getRandomWords() -> (String, String) {
        let n = WordCollection.random.count
        let wordIndices = (Int.random(in: 0...n-1), Int.random(in: 0...n-1))
        return (WordCollection.random[wordIndices.0], WordCollection.random[wordIndices.1])
    }
}
