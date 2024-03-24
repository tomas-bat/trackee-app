//
//  Created by Tomáš Batěk on 15.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import UIToolkit
import SFSafeSymbols

struct RegisterCredentialsView: View {
    
    private enum Focus {
        case email, newPassword, verifyPassword
    }
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 16
    private let fieldSpacing: CGFloat = 8
    
    // MARK: - Stored properties
    
    private let onRegisterTap: () -> Void
    
    @Binding private var email: String
    @Binding private var newPassword: String
    @Binding private var verifyPassword: String
    
    @State private var newPasswordShown = false
    @State private var verifyPasswordShown = false
    
    @FocusState private var focus: Focus?
    
    // MARK: - Init
    
    init(
        email: Binding<String>,
        newPassword: Binding<String>,
        verifyPassword: Binding<String>,
        onRegisterTap: @escaping () -> Void
    ) {
        self._email = email
        self._newPassword = newPassword
        self._verifyPassword = verifyPassword
        self.onRegisterTap = onRegisterTap
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: spacing) {
            VStack(spacing: fieldSpacing) {
                TextField(
                    L10n.register_view_email_placeholder,
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
                    placeholder: L10n.register_view_new_password_placeholder,
                    focused: focus == .newPassword,
                    passwordShown: newPasswordShown,
                    text: $newPassword
                )
                .textFieldStyle(
                    PasswordTextFieldStyle(passwordShown: newPasswordShown) {
                        newPasswordShown.toggle()
                    }
                )
                .focused($focus, equals: .newPassword)
                .onTapGesture {
                    focus = .newPassword
                }
                .textContentType(.newPassword)
                
                PasswordTextField(
                    placeholder: L10n.register_view_new_password_again_placeholder,
                    focused: focus == .verifyPassword,
                    passwordShown: verifyPasswordShown,
                    text: $verifyPassword
                )
                .textFieldStyle(
                    PasswordTextFieldStyle(passwordShown: verifyPasswordShown) {
                        verifyPasswordShown.toggle()
                    }
                )
                .focused($focus, equals: .verifyPassword)
                .onTapGesture {
                    focus = .verifyPassword
                }
                .textContentType(.newPassword)
            }
            
            Button(
                L10n.register_view_button_title,
                action: onRegisterTap
            )
            .buttonStyle(.primary)
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
    }
}

#if DEBUG
struct RegisterCredentialsView_Previews: PreviewProvider {
    struct PreviewView: View {
        @State var email = ""
        @State var newPassword = ""
        @State var verifyPassword = ""
        
        var body: some View {
            RegisterCredentialsView(
                email: $email,
                newPassword: $newPassword,
                verifyPassword: $verifyPassword,
                onRegisterTap: {}
            )
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
#endif
