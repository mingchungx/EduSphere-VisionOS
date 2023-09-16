//
//  AboutView.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        content
    }
    
    var content: some View {
        HStack(spacing: 100) {
            sideImage
            text
        }
    }
    
    var sideImage: some View {
        Image("EduSphere_logo")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
            .padding(.leading, 200)
    }
    
    var text: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(AboutInfo.header)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
            Text(AboutInfo.body)
        }
        .padding(.trailing, 200)
    }
}

#Preview {
    AboutView()
}
