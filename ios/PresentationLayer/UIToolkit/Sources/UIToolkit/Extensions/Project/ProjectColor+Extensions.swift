//
//  Created by Tomáš Batěk on 17.05.2024
//  Copyright © 2024 Matee. All rights reserved.
//

import Foundation
import KMPSharedDomain
import SwiftUI

public extension ProjectColor {
    var text: String {
        switch self {
        case .red: L10n.project_color_red
        case .green: L10n.project_color_green
        case .blue: L10n.project_color_blue
        case .yellow: L10n.project_color_yellow
        case .pink: L10n.project_color_pink
        case .black: L10n.project_color_black
        }
    }
    
    var actual: Color {
        switch self {
        case .red: Color.red
        case .green: Color.green
        case .blue: Color.blue
        case .yellow: Color.yellow
        case .pink: Color.pink
        case .black: Color.black
        }
    }
    
    var image: Image {
        switch self {
        case .black: Asset.Images.blackProject.image
        case .green: Asset.Images.greenProject.image
        case .red: Asset.Images.redProject.image
        case .blue: Asset.Images.blueProject.image
        case .yellow: Asset.Images.yellowProject.image
        case .pink: Asset.Images.pinkProject.image
        }
    }
    
    var circle: some View {
        Circle()
            .fill(actual)
    }
}
