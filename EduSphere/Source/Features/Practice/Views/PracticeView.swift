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
            .onAppear {
                Task {
                    await updateView()
                    showImmersiveSpace = true
                }
            }
    }
    
    var content: some View {
        VStack {
            refreshButton
            Spacer()
            fillInTheBank(text: practiceViewModel.currentImmersion.sentence)
            textfield
            Spacer()
        }
    }
    
    var refreshButton: some View {
        HStack {
            Spacer()
            Button {
                Task {
                    await showNext()
                }
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
        }
        .padding()
    }
}

// MARK: Game
extension PracticeView {
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
    func updateView() async {
        
    }
    
    func showNext() async {
        showImmersiveSpace = false
        await practiceViewModel.setNextImmersion(
            src: "english",
            dest: languageManager.language.lowercased()
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            text = ""
            Immersion.state = practiceViewModel.currentImmersion.assetName
            debugPrint(Immersion.state)
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
    }
}

#Preview {
    PracticeView()
}
