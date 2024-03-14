//
//  Created by Tomáš Batěk on 14.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct PasswordTextField: View {
    
    // MARK: - Stored properties
    
    private let placeholder: String
    private let focused: Bool
    private let passwordShown: Bool
    
    @Binding private var text: String
    
    // MARK: - Init
    
    public init(
        placeholder: String,
        focused: Bool,
        passwordShown: Bool,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self.focused = focused
        self.passwordShown = passwordShown
        self._text = text
    }
    
    public var body: some View {
        ZStack {
            SecureField(placeholder, text: $text)
                .opacity(passwordShown ? 0 : 1)
            
            TextField(placeholder, text: $text)
                .opacity(passwordShown ? 1 : 0)
        }
    }
}

#if DEBUG
struct PasswordTextField_Previews: PreviewProvider {
    struct PreviewView: View {
        @State var text = ""
        @State var focused = false
        @State var passwordShown = false
        
        var body: some View {
            VStack {
                PasswordTextField(
                    placeholder: "Placeholder",
                    focused: focused,
                    passwordShown: passwordShown,
                    text: $text
                )
                
                Button("Toggle password") {
                    passwordShown.toggle()
                }
                
                Text("focused = \(focused ? "true" : "false")")
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
#endif
