//
//  ContentView.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @ObservedObject var languageManager = LanguageManager.shared
    
    var body: some View {
        content
            .glassBackgroundEffect()
    }
    
    var content: some View {
        VStack {
            header
            Divider()
                .padding()
            navigator
        }
    }
    
    var header: some View {
        HStack {
            Text("EduSphere")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Spacer()
            languagePicker
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    var languagePicker: some View {
        Picker("Language", selection: $languageManager.language) {
            ForEach(Language.languages, id: \.self) { language in
                Text(language.uppercased())
            }
        }
    }
    
    var navigator: some View {
        TabView {
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
            
            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "graduationcap")
                }
            
            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "camera.viewfinder")
                }
            
            ChatbotView()
                .tabItem {
                    Label("Chatbot", systemImage: "text.bubble")
                }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
