//
//  Created by Tomáš Batěk on 27.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct InfoTextFieldStyle: TextFieldStyle {
    
    // MARK: - Constants
    
    private let padding: CGFloat = 8
    private let cornerRadius: CGFloat = 4
    
    // MARK: - Stored properties
    
    // MARK: - Init
    
    // MARK: - Body
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(padding)
            .background(AppTheme.Colors.field)
            .clipShape(RoundedRectangle(cornerSize: cornerRadius.squared))
    }
}

#if DEBUG
struct InfoTextFieldStyle_Previews: PreviewProvider {
    struct PreviewView: View {
        
        @State var text = ""
        
        var body: some View {
            TextField("Placeholder", text: $text, axis: .vertical)
                .textFieldStyle(.info)
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}

#endif
