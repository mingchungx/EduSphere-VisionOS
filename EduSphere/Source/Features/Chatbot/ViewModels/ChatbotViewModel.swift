//
//  ChatbotViewModel.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import Foundation
import Alamofire

@MainActor
final class ChatbotViewModel: ObservableObject {
    @Published var messages: [String] = []
    
    func respond(msg: String) async {
        let endpoint = "http://127.0.0.1:5000/chatbot-query"
        let parameters: Parameters = [
            "msg": msg
        ]
        self.messages.append(msg)
        AF.request(endpoint, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                /*
                // Process data on success
                if let string = String(data: data, encoding: .utf8) {
                    self.messages.append(string.capitalized)
                }
                 */
                // Process data on success
                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let jsonDict = json as? [String: Any] {
                    let reply = jsonDict["reply"] as? String

                    // Access and use the extracted components as needed
                    print("Reply:", reply ?? "")
                    
                    self.messages.append(reply ?? "")
                }
            case .failure(_):
                // Ignore error case
                debugPrint("Failed")
            }
        }
    }
}

