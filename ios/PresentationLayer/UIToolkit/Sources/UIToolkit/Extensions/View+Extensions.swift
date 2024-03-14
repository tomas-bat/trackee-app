//
//  Created by Petr Chmelar on 12.03.2022
//  Copyright © 2022 Matee. All rights reserved.
//

import SwiftUI

@MainActor
public extension View {
    @inlinable func lifecycle(_ viewModel: BaseViewModel) -> some View {
        self
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}

public extension View {
    /// Redact a view with a shimmering effect aka show a skeleton
    /// - Inspiration taken from [Redacted View Modifier](https://www.avanderlee.com/swiftui/redacted-view-modifier/)
    @ViewBuilder
    func skeleton(
        _ condition: @autoclosure () -> Bool,
        duration: Double = 1.5,
        bounce: Bool = false
    ) -> some View {
        redacted(reason: condition() ? .placeholder : [])
            .shimmering(active: condition(), duration: duration, bounce: bounce)
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func animateContent<V: Equatable>(
        _ value: V,
        animation: Animation = .easeIn(duration: 0.2),
        transition: AnyTransition = .opacity
    ) -> some View {
        modifier(
            AnimateContentModifier(
                value: value,
                animation: animation,
                transition: transition
            )
        )
    }
}

public extension View {
    func toastView(_ toastData: Binding<ToastData?>) -> some View {
        modifier(ToastViewModifier(toastData: toastData))
    }
}
