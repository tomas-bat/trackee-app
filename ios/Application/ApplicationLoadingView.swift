//
//  Created by Tomáš Batěk on 15.03.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI
import UIToolkit

struct ApplicationLoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }
}

#if DEBUG
#Preview {
    ApplicationLoadingView()
}
#endif
