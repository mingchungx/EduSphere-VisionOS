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
        }
        .padding(.horizontal)
        .padding(.top)
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
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
