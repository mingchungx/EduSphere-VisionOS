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
            Text(languageManager.language.uppercased())
                .font(.callout)
                .fontWeight(.bold)
                .padding()
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    var languagePicker: some View {
        Picker("Language", selection: $languageManager.language) {
            ForEach(Language.languages, id: \.self) { language in
                Text(language)
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
