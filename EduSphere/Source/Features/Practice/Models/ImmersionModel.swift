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
        Immersion(missingWord: "space", assetName: "StarfieldScene", sentence: "I am floating in ___."), // I am in SPACE.
        Immersion(missingWord: "dock", assetName: "DockScene", sentence: "I am on a ___, next to the water."), // I am on a DOCK.
        Immersion(missingWord: "church", assetName: "ChurchScene", sentence: "Be quiet, we are in a ___."), // Be quiet, we are in a CHURCH.
        Immersion(missingWord: "park", assetName: "ParkScene", sentence: "The weather is nice at the ___."), // The weather is nice at the PARK.
        Immersion(missingWord: "living room", assetName: "LivingRoomScene", sentence: "The ___ is very comfortable."), // The LIVING ROOM is very comfortable.
        Immersion(missingWord: "bridge", assetName: "BridgeScene", sentence: "The ___ shines at night.") // The BRIDGE shines at night.
    ]}()
}
