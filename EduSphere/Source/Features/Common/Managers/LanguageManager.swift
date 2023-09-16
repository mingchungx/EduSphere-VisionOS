//
//  LanguageManager.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import Foundation

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var language: String = "english"
    
    init() {
        
    }
}
