//
//  Created by Petr Chmelar on 28/01/2019.
//  Copyright © 2019 Matee. All rights reserved.
//

import SwiftUI
import UIKit

public enum AppTheme {

    /// Defines all the colors used in the app in a semantic way
    public enum Colors {
        
        public static let foreground = Asset.Colors.foreground.color
        public static let foregroundSecondary = Asset.Colors.foregroundSecondary.color
        
        public static let field = Asset.Colors.field.color
        
        public static let background = Asset.Colors.background.color
    }
    
    /// Defines all the fonts used in the app in a semantic way
    public enum Fonts {
        
        public static let body: Font = UIFont.preferredFont(forTextStyle: .body, weight: .regular, size: 13)
        
        public static let headline: Font = UIFont.preferredFont(forTextStyle: .headline, weight: .semibold, size: 14)
        public static let headlineAdditional: Font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular, size: 14)
        
        public static let screenTitle: Font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold, size: 32)
    }
}
