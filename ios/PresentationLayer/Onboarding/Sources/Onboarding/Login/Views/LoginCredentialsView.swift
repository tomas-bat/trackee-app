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
    
    private let onLoginTap: () -> Void
    
    @Binding private var email: String
    @Binding private var password: String
    
    @State private var passwordShown = false
    
    @FocusState private var focus: Focus?
    
    // MARK: - Init
    
    init(
        email: Binding<String>,
        password: Binding<String>,
        onLoginTap: @escaping () -> Void
    ) {
        self._email = email
        self._password = password
        self.onLoginTap = onLoginTap
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
                    PrimaryTextFieldStyle(
                        image: Image(systemSymbol: .envelope)
                    )
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
                    PasswordTextFieldStyle(passwordShown: passwordShown) {
                        passwordShown.toggle()
                    }
                )
                .focused($focus, equals: .password)
                .onTapGesture {
                    focus = .password
                }
                .textContentType(.password)
            }
            
            Button(
                L10n.login_view_login_with_credentials_button_title,
                action: onLoginTap
            )
            .buttonStyle(.primary)
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
                email: $email,
                password: $password,
                onLoginTap: {}
            )
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
#endif

