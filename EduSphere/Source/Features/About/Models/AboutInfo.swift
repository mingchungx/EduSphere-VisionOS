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
        "EduSphere is an interactive language learning app designed to provide a unique language learning experience. EduSphere includes many games: Multiple choice and a Chatbot. \n\nMultiple choice presents a 3d model of an object and three options to choose from. Be careful, too many wrong choices will end the game! \n\nThe chatbot allows the ability to practice writing any language with real time responses. \n\nChange the language of your game in the top right selector."
    }()
}
