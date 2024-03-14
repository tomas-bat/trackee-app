//
//  Created by Tomáš Batěk on 14.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import SwiftUI

public struct AnimateContentModifier<V: Equatable>: ViewModifier {
    
    // MARK: - Stored properties
    
    private var value: V
    private var animation: Animation
    private var transition: AnyTransition
    
    // MARK: - Init
    
    init(
        value: V,
        animation: Animation,
        transition: AnyTransition
    ) {
        self.value = value
        self.animation = animation
        self.transition = transition
    }

    // MARK: - Body and views
    
    public func body(content: Content) -> some View {
        content
            .transition(transition)
            .animation(animation, value: value)
    }
}
