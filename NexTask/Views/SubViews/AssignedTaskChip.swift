//
//  AssignedTaskChip.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import SwiftUI

struct AssignedTaskChip: View {
    let taskCount: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: SFSymbols.tasks)
            Text(String(format: L10n.Tasks.assignedCount, taskCount))
        }
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.blue.opacity(0.15))
        .clipShape(Capsule())
    }
}
