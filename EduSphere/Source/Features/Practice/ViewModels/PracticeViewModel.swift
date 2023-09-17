//
//  PracticeViewModel.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-17.
//

import Foundation
import Alamofire

@MainActor
final class PracticeViewModel: ObservableObject {
    @Published var currentImmersion: Immersion = Immersion.immersions[0]
    @Published var currentIndex: Int = 0
    
    func setNextImmersion(src: String, dest: String) async {
        let nextIndex = getNextPosition(index: self.currentIndex)
        self.currentIndex = nextIndex
        await translateImmersion(
            immersion: Immersion.immersions[nextIndex],
            src: src,
            dest: dest
        )
        self.currentImmersion.assetName = Immersion.immersions[nextIndex].assetName
    }
    
    func translateImmersion(immersion: Immersion, src: String, dest: String) async {
        self.currentImmersion.missingWord = await returnTranslation(text: immersion.missingWord, src: src, dest: dest)
        self.currentImmersion.sentence = await returnTranslation(text: immersion.sentence, src: src, dest: dest)
    }
    
    private func returnTranslation(text: String, src: String, dest: String) async -> String {
        let endpoint = "http://127.0.0.1:5000/translate"
        let parameters: Parameters = [
            "word": text,
            "src": src,
            "dest": dest
        ]
        
        return await withCheckedContinuation { continuation in
            AF.request(endpoint, parameters: parameters).responseData { response in
                switch response.result {
                case .success(let data):
                    // Process data on success
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []), let jsonDict = json as? [String: Any] {
                        let translation = jsonDict["translation"] as? String

                        // Access and use the extracted components as needed
                        print("Translation:", translation ?? "")
                        
                        continuation.resume(returning: translation ?? "")
                    }
                case .failure(_):
                    // Ignore error case
                    continuation.resume(returning: "")
                }
            }
        }
    }
    
    func checkCorrect(input: String, ans: String) -> Bool {
        return input.lowercased() == ans.lowercased()
    }
    
    func getNextPosition(index: Int) -> Int {
        // Assumes non-zero length Immersion.immersions
        if index == Immersion.immersions.count - 1 {
            return 0
        } else {
            return index + 1
        }
    }
}
