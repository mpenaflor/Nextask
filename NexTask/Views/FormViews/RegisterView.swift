//
//  RegisterView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var isLoading = false
    
    enum Field {
        case email, password, confirmPassword
    }
    @FocusState private var focusedField: Field?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
                .frame(height: 70)
            
            // Title
            VStack(spacing: 8) {
                Text(L10n.Auth.registerGreeting)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
            }
            
            // Fields
            VStack(spacing: 16) {
                TextField(L10n.Auth.email, text: $email)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                SecureField(L10n.Auth.password, text: $password)
                    .focused($focusedField, equals: .password)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                SecureField(L10n.Auth.confirmPassword, text: $confirmPassword)
                    .focused($focusedField, equals: .confirmPassword)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // Register Button
            Button {
                // Dismiss Keyboard
                focusedField = nil
                
                guard !isLoading else { return }
                
                isLoading = true
                
                Task {
                    await auth.register(email: email, password: password, confirmPassword: confirmPassword)
                    isLoading = false
                }
            } label: {
                ZStack {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text(L10n.Auth.signup.uppercased())
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(isLoading)
            
            // Back to login
            Button {
                dismiss()
            } label: {
                Text(L10n.Auth.loginLink)
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: auth.errorMessage)
        .alert(L10n.Auth.registerErrorTitle, isPresented: .constant(auth.errorMessage != nil)) {
            Button(L10n.General.ok) {
                auth.errorMessage = nil
            }
        } message: {
            Text(auth.errorMessage ?? "")
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}
