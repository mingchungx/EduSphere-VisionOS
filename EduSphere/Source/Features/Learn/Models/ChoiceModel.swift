//
//  ChoiceModel.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import Foundation
import SwiftUI

struct Choice: Identifiable {
    let id = UUID()
    var text: String
    var correct: Bool
    var color: Color
}

extension Choice {
    // Choices will always be of length 3, with color ordered as RED, BLUE, YELLOW
    static let choices: [Choice] = {[
        Choice(text: "Le Chaise", correct: false, color: Color.red),
        Choice(text: "La Chaise", correct: true, color: Color.blue),
        Choice(text: "The Chair", correct: false, color: Color.yellow)
    ]}()
}
