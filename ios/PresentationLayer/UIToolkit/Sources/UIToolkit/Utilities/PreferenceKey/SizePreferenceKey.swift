//
//  Created by Tomáš Batěk on 11.04.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
