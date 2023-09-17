//
//  PracticeView.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-17.
//

import SwiftUI

struct PracticeView: View {
    // State Variables
    @State private var text: String = ""
    @State private var showImmersiveSpace: Bool = false
    @State private var immersiveSpaceIsShown: Bool = false
    @State private var loadingNext: Bool = false
    
    // ObservedObjects
    @ObservedObject private var practiceViewModel = PracticeViewModel()
    @ObservedObject private var languageManager = LanguageManager.shared
    
    // Environment Variables
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
            if showImmersiveSpace {
                // Game
                gameHeader
                Spacer()
                fillInTheBank(text: practiceViewModel.currentImmersion.sentence)
                textfield
                Spacer()
            } else if !showImmersiveSpace && loadingNext {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                edusphereLogo
                largeTitle
                description
                playButton
                Spacer()
                HStack {
                    Text("Spacer")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .opacity(0.7)
                }
                .padding()
                .opacity(0)
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
        Text("Practice")
            .font(.extraLargeTitle)
            .fontWeight(.semibold)
    }
    
    var description: some View {
        Text("Go into virtual reality and explore your surrounds, discovering new words to describe your location!")
            .padding()
    }
    
    var playButton: some View {
        Button {
            Task {
                await practiceViewModel.initalizeImmersion(src: "english", dest: languageManager.language.lowercased())
                showImmersiveSpace = true
            }
        } label: {
            Image(systemName: "arrowtriangle.forward.fill")
                .resizable()
                .scaledToFit()
                .padding(50)
                .frame(width: 200, height: 200)
        }
    }
}

// MARK: Game
extension PracticeView {
    var gameHeader: some View {
        HStack {
            Image(systemName: "arrow.left")
            Button {
                showImmersiveSpace = false
            } label: {
                Text("Quit")
            }
            Spacer()
            Button {
                Task {
                    await showNext()
                }
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    
    @ViewBuilder
    func fillInTheBank(text: String) -> some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding()
    }
    
    var textfield: some View {
        HStack {
            TextField("Fill in the blank...", text: $text)
                .foregroundStyle(Color.white)
                .onSubmit {
                    Task {
                        await submitAns()
                    }
                }
            Button {
                Task {
                    await submitAns()
                }
            } label: {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
            }
        }
        .padding()
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 20)
        )
        .padding()
        .shadow(radius: 3)
    }
}

// MARK: Functions
extension PracticeView {
    func showNext() async {
        showImmersiveSpace = false
        loadingNext = true
        await practiceViewModel.setNextImmersion(
            src: "english",
            dest: languageManager.language.lowercased()
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            text = ""
            Immersion.state = practiceViewModel.currentImmersion.assetName
            debugPrint(Immersion.state)
            loadingNext = false
            showImmersiveSpace = true
        }
    }
    
    private func submitAns() async {
        if practiceViewModel.checkCorrect(
            input: text,
            ans: practiceViewModel.currentImmersion.missingWord
        ) {
            await showNext()
        } else {
            // Alter user it was wrong
        }
        text = ""
    }
}

#Preview {
    PracticeView()
}
