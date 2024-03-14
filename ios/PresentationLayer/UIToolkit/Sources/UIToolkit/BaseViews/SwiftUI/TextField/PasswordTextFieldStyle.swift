//
//  Created by Tomáš Batěk on 14.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import SFSafeSymbols

public struct PasswordTextFieldStyle: TextFieldStyle {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 16
    private let imageSize: CGFloat = 24
    private let padding: CGFloat = 16
    private let height: CGFloat = 50
    private let horizontalExtraPadding: CGFloat = 8
    private let lineImageSize: CGFloat = 20
    
    // MARK: - Stored properties
    
    private let image: Image
    private let passwordShown: Bool
    private let onShowTap: () -> Void
    
    // MARK: - Init
    
    public init(
        image: Image = Image(systemSymbol: .lock),
        passwordShown: Bool,
        onShowTap: @escaping () -> Void
    ) {
        self.image = image
        self.passwordShown = passwordShown
        self.onShowTap = onShowTap
    }
    
    // MARK: - Body
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: spacing) {
            image
                .resizable()
                .scaledToFit()
                .frame(
                    width: imageSize,
                    height: imageSize
                )
            
            configuration
                .font(AppTheme.Fonts.body)
            
            Button(action: onShowTap) {
                Image(systemSymbol: .eye)
                    .if(passwordShown) { view in
                        view.overlay(
                            Image(systemSymbol: .lineDiagonal)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: lineImageSize,
                                    height: lineImageSize
                                )
                        )
                    }
            }
            .foregroundStyle(AppTheme.Colors.foreground)
        }
        .padding(padding)
        .padding(.horizontal, horizontalExtraPadding)
        .frame(height: height)
        .background(AppTheme.Colors.field)
        .clipShape(
            RoundedRectangle(cornerSize: .init(width: height / 2, height: height / 2))
        )
    }
}

#if DEBUG
struct PasswordTextFieldStyle_Previews: PreviewProvider {
    struct PreviewView: View {
        @State var text = ""
        @State var focused = false
        @State var passwordShown = false
        
        var body: some View {
            PasswordTextField(
                placeholder: "Placeholder",
                focused: focused,
                passwordShown: passwordShown,
                text: $text
            )
            .textFieldStyle(
                PasswordTextFieldStyle(
                    passwordShown: passwordShown,
                    onShowTap: {
                        passwordShown.toggle()
                    }
                )
            )
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
#endif
