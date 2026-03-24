//
//  TagChip.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-23.
//

import SwiftUI

struct TagChip: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(color.opacity(0.15))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
