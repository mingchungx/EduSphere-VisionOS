//
//  LearnView.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import SwiftUI
import RealityKit

// MARK: Main
struct LearnView: View {
    @State private var highestScore: Int = 0
    @State private var score: Int = 0
    @State private var hearts: Int = 3
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    @ObservedObject private var learnViewModel = LearnViewModel()
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        content
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
    }
    
    var content: some View {
        VStack {
            if !showImmersiveSpace {
                header
            } else {
                game
            }
            playButton
        }
    }
    
    var header: some View {
        Group {
            Text("Learn now by clicking play")
            Text("Highest score: \(highestScore)")
            Text("Selected language: FRENCH")
        }
    }
    
    var playButton: some View {
        Button {
            highestScore = max(highestScore, score)
            score = 0
            hearts = 3
            showImmersiveSpace.toggle()
        } label: {
            Text(showImmersiveSpace ? "Close" : "Play")
        }
    }
}

// MARK: Game
extension LearnView {
    var game: some View {
        VStack {
            // You can put models in their own directory as usdz or fetch from from a url
            scoreHeader
            itemModel
            translationChoices
        }
    }
    
    var itemModel: some View {
        // Asynchronous Model Retrieval
        Model3D(url: URL(string: "https://storage.googleapis.com/edusphere/desk_chair_low.usdz")!) { model in
            model
                .resizable()
                .scaledToFit()
                .frame(height: 300)
        } placeholder: {
            ProgressView()
        }
    }
    
    var scoreHeader: some View {
        Group {
            Text("Highest Score: \(highestScore)")
            HStack {
                Text("Your Score: \(score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                HStack {
                    Image(systemName: hearts >= 1 ? "heart.fill" : "heart")
                    Image(systemName: hearts >= 2 ? "heart.fill" : "heart")
                    Image(systemName: hearts >= 3 ? "heart.fill" : "heart")
                }
            }
        }
    }
    
    var translationChoices: some View {
        HStack(spacing: 50) {
            Button {
                score += 1
            } label: {
                Text("Le Chaise")
            }
            Button {
                score += 1
            } label: {
                Text("La Chaise")
            }
            Button {
                hearts -= 1
            } label: {
                Text("La Chair")
            }
        }
        .padding()
        .onChange(of: hearts) {
            if hearts <= 0 {
                highestScore = max(highestScore, score)
                score = 0
                hearts = 3
                showImmersiveSpace.toggle()
            }
        }
    }
}

// MARK: Preview
#Preview {
    LearnView()
}
