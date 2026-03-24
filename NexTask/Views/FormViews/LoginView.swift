//
//  LoginView.swift
//  NexTask
//
//  Created by Mai Peñaflor on 2026-03-24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    
    @State private var isLoading = false
    
    enum Field {
        case email, password
    }
    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 150)
                
                // Title
                VStack(spacing: 8) {
                    Text(L10n.Auth.loginGreeting)
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
                }
                
                Button {
                    // Dismiss Keyboard
                    focusedField = nil
                    
                    guard !isLoading else { return }
                    
                    isLoading = true
                    
                    Task {
                        await auth.login(email: email, password: password)
                        isLoading = false
                    }
                } label: {
                    ZStack {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text(L10n.Auth.login.uppercased())
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
                
                
                // Register Link
                Button {
                    showRegister = true
                } label: {
                    Text(L10n.Auth.registerLink)
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
            .animation(.easeInOut, value: auth.errorMessage)
            .alert(L10n.Auth.loginErrorTitle, isPresented: .constant(auth.errorMessage != nil)) {
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
}
