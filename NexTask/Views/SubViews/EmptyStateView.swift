//
//  EmptyStateView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-21.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String?
    let systemImage: String?

    var body: some View {
        VStack(spacing: 12) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }

            Text(title)
                .font(.headline)

            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
