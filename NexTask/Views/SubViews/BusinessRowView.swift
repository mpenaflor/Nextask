//
//  BusinessRowView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-23.
//

import SwiftUI

struct BusinessRowView: View {
    @Environment(\.editMode) private var editMode

    @ObservedObject var business: Business
    let categories: [String]?
    let tags: [String]?
    
    let onTagTap: (String) -> Void
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
            
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: SFSymbols.business)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(business.name ?? L10n.Business.unknown)
                    .font(.headline)
                
                if let email = business.email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if let tasks = business.tasks, tasks.count > 0 {
                    AssignedTaskChip(taskCount: tasks.count)
                }
                
                // Categories
                if let categories, !categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { tag in
                                TagChip(title: tag, color: Color.orange) {
                                    onTagTap(tag)
                                }
                            }
                        }
                    }
                }
                
                // Tags (tappable chips)
                if let tags, !tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                TagChip(title: tag, color: Color.green) {
                                    onTagTap(tag)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
