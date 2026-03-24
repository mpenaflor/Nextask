//
//  TaskRowView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var viewModel: TasksViewModel

    let task: TaskItem
    let showAssignee: Bool
    
    private var getAssigneeIcon: String? {
        if task.person != nil  {
            return SFSymbols.person
        }
        if task.business != nil  {
            return SFSymbols.business
        }
        return nil
    }
    
    private var getAssigneeName: String? {
        if let person = task.person  {
            return Utils.getDiplayName(person)
        }
        if let business = task.business  {
            return business.name ?? nil
        }
        
        return nil
    }
    
    private var getStatusDisplay: String {
        if task.isCompleted {
            return L10n.Tasks.statusCompleted.uppercased()
        }
        
        return L10n.Tasks.statusOpen.uppercased()
    }
    
    private var getStatusColor: Color {
        if task.isCompleted {
            return Color.green
        }
        
        return Color.blue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(getStatusDisplay)
                .font(.caption)
                .fontWeight(.bold)
                .padding(5)
                .background(getStatusColor)
                .foregroundColor(.white)
                .cornerRadius(5)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Title
            Text(task.title ?? L10n.Tasks.emptyTitle)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Description
            Text(task.taskDescription ?? L10n.Tasks.emptyMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Spacer()
            
            if showAssignee, let assigneeIcon = getAssigneeIcon, let assigneeName = getAssigneeName {
                // Assignee
                HStack(spacing: 6) {
                    Image(systemName: assigneeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15) // icon size inside
                        .foregroundStyle(.blue)
                        .frame(width: 30, height: 30) // container size
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Text(assigneeName)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}
