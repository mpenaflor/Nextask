//
//  ProfileSectionView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import SwiftUI
import FirebaseAuth

struct ProfileSectionView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Text(auth.user?.email?.prefix(1).uppercased() ?? "?")
                .font(.headline)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(auth.user?.email ?? "No Email")
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
