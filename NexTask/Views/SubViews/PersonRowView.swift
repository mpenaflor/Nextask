//
//  PersonRowView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-23.
//

import SwiftUI

struct PersonRowView: View {
    @ObservedObject var viewModel: PeopleViewModel
    
    let person: Employee
    
    var onTagTap: (String) -> Void = { _ in }
    
    private var tags: [String]? {
        return viewModel.getTagNames(person: person)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: SFSymbols.person)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 22))
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(Utils.getDiplayName(person) ?? L10n.People.unknown)
                    .font(.headline)
                
                if let business = person.business?.name {
                    HStack {
                        Image(systemName: SFSymbols.business)
                            .foregroundStyle(.secondary)
                            .frame(width: 15, height: 15)
                        Text(business)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let email = person.email {
                    HStack {
                        Image(systemName: SFSymbols.envelope)
                            .foregroundStyle(.secondary)
                            .frame(width: 15, height: 15)
                        Text(email)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let phone = person.phone {
                    HStack {
                        Image(systemName: SFSymbols.phone)
                            .foregroundStyle(.secondary)
                            .frame(width: 15, height: 15)
                        Text(phone)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                
                if let tasks = person.tasks, tasks.count > 0 {
                    AssignedTaskChip(taskCount: tasks.count)
                }
                
                if let tags, !tags.isEmpty {
                    Spacer(minLength: 6)
                    
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
