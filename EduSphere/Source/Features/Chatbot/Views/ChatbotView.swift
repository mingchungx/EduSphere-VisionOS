//
//  ChatbotView.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import SwiftUI

struct ChatbotView: View {
    @State private var text: String = ""
    
    @ObservedObject private var chatbotViewModel = ChatbotViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                messages
                keyboard
            }
        }
    }
    
    var messages: some View {
        ForEach(chatbotViewModel.messages.indices, id: \.self) { index in
            alternatingView(for: index)
        }
    }
    
    @ViewBuilder
    func alternatingView(for index: Int) -> some View {
        Group {
            if index % 2 == 0 {
                // Display something different for even-indexed elements
                userMessage(query: chatbotViewModel.messages[index])
            } else {
                // Display something different for odd-indexed elements
                botMessage(response: chatbotViewModel.messages[index])
            }
        }
    }
    
    var keyboard: some View {
        HStack {
            TextField("Send a message...", text: $text)
                .foregroundStyle(Color.white)
                .opacity(1)
            Button {
                Task {
                    await chatbotViewModel.respond(msg: text)
                    text = ""
                }
            } label: {
                Image(systemName: "paperplane.fill")
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
    
    @ViewBuilder
    func botMessage(response: String) -> some View {
        HStack {
            Image("Robot")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .shadow(radius: 3)
            Text(response)
        }
        .padding()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 20)
        )
        .padding()
    }
    
    @ViewBuilder
    func userMessage(query: String) -> some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .shadow(radius: 3)
            Text(query)
        }
        .padding()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 20)
        )
        .padding()
    }
}

#Preview {
    ChatbotView()
}
