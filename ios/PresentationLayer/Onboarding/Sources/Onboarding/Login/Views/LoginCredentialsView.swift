//
//  Created by Tomáš Batěk on 14.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import UIToolkit
import SFSafeSymbols

struct LoginCredentialsView: View {
    
    private enum Focus {
        case email, password
    }
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 16
    private let fieldSpacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    private let credentialsLoading: Bool
    private let appleLoading: Bool
    private let onLoginTap: () -> Void
    private let onAppleTap: () -> Void
    
    @Binding private var email: String
    @Binding private var password: String
    
    @State private var passwordShown = false
    
    @FocusState private var focus: Focus?
    
    // MARK: - Init
    
    init(
        credentialsLoading: Bool,
        appleLoading: Bool,
        email: Binding<String>,
        password: Binding<String>,
        onLoginTap: @escaping () -> Void,
        onAppleTap: @escaping () -> Void
    ) {
        self.credentialsLoading = credentialsLoading
        self.appleLoading = appleLoading
        self._email = email
        self._password = password
        self.onLoginTap = onLoginTap
        self.onAppleTap = onAppleTap
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: spacing) {
            VStack(spacing: fieldSpacing) {
                TextField(
                    L10n.login_view_email_placeholder,
                    text: $email
                )
                .textFieldStyle(
                    .primary(image: Image(systemSymbol: .envelope))
                )
                .focused($focus, equals: .email)
                .onTapGesture {
                    focus = .email
                }
                .textContentType(.emailAddress)
                
                PasswordTextField(
                    placeholder: L10n.login_view_password_placeholder,
                    focused: focus == .password,
                    passwordShown: passwordShown,
                    text: $password
                )
                .textFieldStyle(
                    .password(passwordShown: passwordShown) {
                        passwordShown.toggle()
                    }
                )
                .focused($focus, equals: .password)
                .onTapGesture {
                    focus = .password
                }
                .textContentType(.password)
            }
            
            VStack(spacing: fieldSpacing) {
                Button(
                    L10n.login_view_login_with_credentials_button_title,
                    action: onLoginTap
                )
                .buttonStyle(.primary)
                .environment(\.isLoading, credentialsLoading)
             
                Button(
                    L10n.login_view_sign_in_with_apple,
                    action: onAppleTap
                )
                .buttonStyle(.signInWithApple)
                .environment(\.isLoading, appleLoading)
            }
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
    }
}

#if DEBUG
struct LoginCredentialsView_Previews: PreviewProvider {
    struct PreviewView: View {
        @State var email = ""
        @State var password = ""
        
        var body: some View {
            LoginCredentialsView(
                credentialsLoading: false,
                appleLoading: false,
                email: $email,
                password: $password,
                onLoginTap: {},
                onAppleTap: {}
            )
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
#endif

