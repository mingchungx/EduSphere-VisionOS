//
//  AboutInfo.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import Foundation

struct AboutInfo: Identifiable {
    let id = UUID()
}

extension AboutInfo {
    static let header: String = {
        "About"
    }()
    static let body: String = {
        "A new way to learn language new way to learn language new way to learn language new way to learn language new way to learn language new way to learn language new way to learn language new way to learn language new way to learn language v new way to learn language new way to learn language"
    }()
}
