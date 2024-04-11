//
//  Created by Tomáš Batěk on 10.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Combine
import SwiftUI

struct KeyboardScrollModifier: ViewModifier {
    
    enum `Type` {
        case didShow
        case willHide
    }
    
    let type: `Type`
    let function: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(publisher(for: type)) { _ in
                function()
            }
    }
    
    private func publisher(for type: `Type`) -> Publishers.Share<NotificationCenter.Publisher> {
        switch type {
        case .didShow:
            return NotificationCenter.default.publisher(
                for: UIResponder.keyboardDidShowNotification
            ).share()
        case .willHide:
            return NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification
            ).share()
        }
    }
}
