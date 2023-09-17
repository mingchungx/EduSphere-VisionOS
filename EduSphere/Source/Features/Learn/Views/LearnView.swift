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
    @State private var showSceneSpace = false
    @State private var loading = false
    
    @ObservedObject private var learnViewModel = LearnViewModel()
    @ObservedObject private var languageManager = LanguageManager.shared
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        // MARK: Only show immersive space during fill-in-bank
        content
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if showSceneSpace {
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
    }
    
    var content: some View {
        VStack {
            if !showImmersiveSpace {
                edusphereLogo
                largeTitle
                playButton
            } else {
                game
            }
            Spacer()
            if !showImmersiveSpace {
                footer
                Spacer()
            }
        }
    }
    
    var edusphereLogo: some View {
        Image("EduSphere_logo")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
    }
    
    var largeTitle: some View {
        Text("EduSphere")
            .font(.extraLargeTitle)
            .fontWeight(.semibold)
    }
    
    var playButton: some View {
        Button {
            resetView()
            showImmersiveSpace = true
        } label: {
            Image(systemName: "arrowtriangle.forward.fill")
                .resizable()
                .scaledToFit()
                .padding(50)
                .frame(width: 200, height: 200)
        }
    }
    
    var footer: some View {
        HStack {
            Spacer()
            Text("Highest Score: \(highestScore)")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(0.7)
        }
        .padding(.horizontal)
    }
}

// MARK: Game
extension LearnView {
    var game: some View {
        VStack {
            gameHeader
            Spacer()
            if loading {
                ProgressView()
            } else {
                translationChoices
                Spacer()
                itemModel
            }
            Spacer()
            footer
            Spacer()
        }
        .onAppear {
            Task {
                await updateView()
            }
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
        Model3D(url: URL(string: learnViewModel.mod3D.url)!) { model in
            model
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        } placeholder: {
            ProgressView()
        }
    }
    
    var translationChoices: some View {
        HStack(spacing: 70) {
            ForEach(learnViewModel.choices.shuffled()) { c in
                if !c.text.isEmpty {
                    choice(
                        text: c.text,
                        correct: c.correct,
                        color: c.color
                    )
                }
            }
        }
        .padding()
        .onChange(of: hearts) {
            if hearts <= 0 {
                resetView()
            }
        }
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
            Task {
                if correct {
                    score += 1
                    await updateView()
                } else {
                    hearts -= 1
                }
            }
        } label: {
            Text(text)
        }
        /*
        .background(
            color,
            in: RoundedRectangle(cornerRadius: 20)
        )
         */
    }
}

// MARK: Functions
extension LearnView {
    func updateView() async {
        loading.toggle()
        await fetchRandomMod3D()
        // await fetchChoices()
        debugPrint("Updated Game View")
        loading.toggle()
    }
    
    func resetView() {
        highestScore = max(highestScore, score)
        score = 0
        hearts = 5
        showImmersiveSpace = false
    }
    
    func fetchRandomMod3D() async {
        try? await learnViewModel.fetchRandomMod3D(
            src: "english",
            dest: languageManager.language.lowercased()
        )
    }
}

// MARK: Preview
#Preview {
    LearnView()
}
