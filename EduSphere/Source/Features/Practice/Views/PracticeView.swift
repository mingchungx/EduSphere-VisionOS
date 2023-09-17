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
            refreshButton
            Spacer()
            fillInTheBank(text: "Look, we are at the ___.")
            textfield
            Spacer()
        }
    }
    
    var refreshButton: some View {
        HStack {
            Spacer()
            Button {
                
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
            Button {
                Task {
                    // Action
                    text = ""
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

#Preview {
    PracticeView()
}
