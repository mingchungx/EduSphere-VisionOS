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
    @State private var hearts: Int = 5
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
        }
    }
    
    var playButton: some View {
        Group {
            if !showImmersiveSpace {
                Button {
                    highestScore = max(highestScore, score)
                    score = 0
                    hearts = 5
                    showImmersiveSpace = true
                } label: {
                    Text("Play")
                }
            }
        }
    }
}

// MARK: Game
extension LearnView {
    var game: some View {
        VStack {
            gameHeader
            Spacer()
            itemModel
            Spacer()
            translationChoices
            Spacer()
            gameFooter
            Spacer()
        }
    }
    
    var gameHeader: some View {
        HStack {
            HStack {
                Image(systemName: "arrow.left")
                Button {
                    showImmersiveSpace = false
                } label: {
                    Text("Quit")
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    heart(1)
                    heart(2)
                    heart(3)
                    heart(4)
                    heart(5)
                }
                .padding(.vertical)
                Text("Score: \(score)")
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    var itemModel: some View {
        // Asynchronous Model Retrieval
        Model3D(url: URL(string: "https://storage.googleapis.com/edusphere/low_poly/arcade_low.usdz")!) { model in
            model
                .resizable()
                .scaledToFit()
                .frame(height: 300)
        } placeholder: {
            ProgressView()
        }
    }
    
    var translationChoices: some View {
        HStack(spacing: 70) {
            ForEach(Choice.choices) { c in
                choice(
                    text: c.text,
                    correct: c.correct,
                    color: c.color
                )
            }
        }
        .padding()
        .onChange(of: hearts) {
            if hearts <= 0 {
                highestScore = max(highestScore, score)
                score = 0
                hearts = 5
                showImmersiveSpace.toggle()
            }
        }
    }
    
    var gameFooter: some View {
        HStack {
            Spacer()
            Text("Highest Score: \(highestScore)")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(0.7)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func heart(_ lowerBound: Int) -> some View {
        Image(systemName: hearts >= lowerBound ? "heart.fill" : "heart")
            .foregroundStyle(Color.red)
            .shadow(radius: 2)
    }
    
    @ViewBuilder
    func choice(text: String, correct: Bool, color: Color) -> some View {
        Button {
            if correct {
                score += 1
            } else {
                hearts -= 1
            }
        } label: {
            Text(text)
        }
        .background(
            color,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

// MARK: Preview
#Preview {
    LearnView()
}
