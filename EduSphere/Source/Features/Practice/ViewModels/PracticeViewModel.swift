//
//  PracticeViewModel.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-17.
//

import Foundation

final class PracticeViewModel: ObservableObject {
    func checkCorrect(input: String, ans: String) -> Bool {
        return input == ans
    }
}
