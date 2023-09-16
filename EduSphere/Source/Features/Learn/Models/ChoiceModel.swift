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
