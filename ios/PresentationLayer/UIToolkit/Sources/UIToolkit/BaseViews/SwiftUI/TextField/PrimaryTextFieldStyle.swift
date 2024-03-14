//
//  Created by Tomáš Batěk on 14.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import SFSafeSymbols

public struct PrimaryTextFieldStyle: TextFieldStyle {
    
    // MARK: - Constants
    
    private let spacing: CGFloat = 16
    private let imageSize: CGFloat = 24
    private let padding: CGFloat = 16
    private let height: CGFloat = 50
    private let horizontalExtraPadding: CGFloat = 8
    
    // MARK: - Stored properties
    
    private let image: Image
    
    // MARK: - Init
    
    public init(
        image: Image
    ) {
        self.image = image
    }
    
    // MARK: - Body
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: spacing) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
            
            configuration
                .font(AppTheme.Fonts.body)
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
struct PrimaryTextFieldStyle_Previews: PreviewProvider {
    struct PreviewView: View {
        @State var text = ""
        
        var body: some View {
            TextField("Placeholder", text: $text)
                .textFieldStyle(
                    PrimaryTextFieldStyle(
                        image: Image(systemSymbol: .envelope)
                    )
                )
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
#endif
