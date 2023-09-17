//
//  ImmersionModel.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import Foundation

// Hard coded random immersive scenery for fill in the blank games
struct Immersion: Identifiable {
    let id = UUID()
    var missingWord: String
    var assetName: String
    var sentence: String
}

extension Immersion {
    static var state: String = {
        "StarfieldScene"
    }()
    
    static let immersions: [Immersion] = {[
        Immersion(missingWord: "space", assetName: "StarfieldScene", sentence: "I am in ___."), // I am in SPACE.
        Immersion(missingWord: "dock", assetName: "DockScene", sentence: "I am on a ___"), // I am on a DOCK.
        Immersion(missingWord: "desert", assetName: "DesertScene", sentence: "It is too hot, because this is the ___."), // It is too hot, because this is the DESERT.
        Immersion(missingWord: "church", assetName: "ChurchScene", sentence: "Be quiet, we are in a ___."), // Be quiet, we are in a CHURCH.
        Immersion(missingWord: "park", assetName: "ParkScene", sentence: "The weather is nice at the ___.")//, // The weather is nice at the PARK.
    ]}()
}
