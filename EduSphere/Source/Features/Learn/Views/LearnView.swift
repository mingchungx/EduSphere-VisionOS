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
    // State Variables
    @State private var highestScore: Int = 0
    @State private var score: Int = 0
    @State private var hearts: Int = 5
    @State private var showingGame: Bool = false
    @State private var loading: Bool = false
    @State private var text: String = ""
    @State private var gameType: String = "MC"
    
    // ObservedObjects
    @ObservedObject private var learnViewModel = LearnViewModel()
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            if !showingGame {
                edusphereLogo
                largeTitle
                description
                playButton
            } else {
                game
            }
            Spacer()
            if !showingGame {
                footer
                    .padding(.vertical)
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
        Text("Learn")
            .font(.extraLargeTitle)
            .fontWeight(.semibold)
    }
    
    var description: some View {
        Text("See everyday 3D objects and learn to name them! However... 5 strikes and you're out!")
            .padding()
    }
    
    var playButton: some View {
        Button {
            resetView()
            showingGame = true
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
                multipleChoice
            }
            Spacer()
            footer
            Spacer()
        }
    }
    
    // Game style 1: fill in the blank
    var fillInTheBlank: some View {
        Group {
            Text(learnViewModel.immersiveScene.sentence)
            TextField("Missing Word", text: $text)
                .keyboardType(.default)
                .onSubmit {
                    Task {
                        if learnViewModel.checkCorrectBlank(text: text) {
                            score += 1
                            // showingGame = false
                            chooseGameType()
                        } else {
                            hearts -= 1
                        }
                    }
                }
        }
        .onAppear {
            Task {
                await updateFIB()
            }
        }
    }
    
    // Game style 2: multiple choice
    var multipleChoice: some View {
        Group {
            translationChoices
            Spacer()
            itemModel
        }
        .onAppear {
            Task {
                await updateMC()
            }
        }
    }
    
    var gameHeader: some View {
        HStack {
            HStack {
                Image(systemName: "arrow.left")
                Button {
                    showingGame = false
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
                    await updateMC()
                    // chooseGameType()
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
    // Updates multiple choice
    func updateMC() async {
        loading.toggle()
        await fetchRandomMod3D()
        // await fetchChoices()
        debugPrint("Updated Game View")
        loading.toggle()
    }
    
    // Updates fill in the bank
    func updateFIB() async {
        loading.toggle()
        showingGame = true
        
        await learnViewModel.getImmersiveScene(src: "english", dest: languageManager.language.lowercased())
        Immersion.state = learnViewModel.immersiveScene.assetName
        
        loading.toggle()
    }
    
    func resetView() {
        highestScore = max(highestScore, score)
        score = 0
        hearts = 5
        showingGame = false
    }
    
    func fetchRandomMod3D() async {
        try? await learnViewModel.fetchRandomMod3D(
            src: "english",
            dest: languageManager.language.lowercased()
        )
    }
    
    private func chooseGameType() {
        let ran = Int.random(in: 1...2)
        if (ran == 1) {
            gameType = "MC"
        } else {
            gameType = "FIB"
        }
        debugPrint("Next game: \(gameType)")
    }
}

// MARK: Preview
#Preview {
    LearnView()
}
