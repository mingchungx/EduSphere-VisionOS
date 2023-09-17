//
//  ImmersiveView.swift
//  EduSphere
//
//  Created by Mingchung Xia on 2023-09-16.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Create a material with a star field on it.
            guard let url = Bundle.main.url(forResource: Immersion.state, withExtension: "jpg"),
                              let resource = try? await TextureResource(contentsOf: url) else {
                // If the asset isn't available, something is wrong with the app.
                fatalError("Unable to load texture.")
            }
            var material = UnlitMaterial()
            material.color = .init(texture: .init(resource))

            // Attach the material to a large sphere.
            let entity = Entity()
            entity.components.set(ModelComponent(
                mesh: .generateSphere(radius: 1000),
                materials: [material]
            ))

            // Ensure the texture image points inward at the viewer.
            entity.scale *= .init(x: -1, y: 1, z: 1)

            content.add(entity)
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
