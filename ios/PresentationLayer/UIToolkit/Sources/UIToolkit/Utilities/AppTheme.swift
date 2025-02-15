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
        public static let fieldFull = Asset.Colors.fieldFull.color
        
        public static let background = Asset.Colors.background.color
        public static let contentBackground = Asset.Colors.contentBackground.color
        
        public static let destructive = Asset.Colors.destructive.color
        public static let onDestructive = Asset.Colors.onDestructive.color
        
        public static let success = Asset.Colors.success.color
        
        public static let appleButtonBackground = Asset.Colors.appleButtonBackground.color
        public static let appleButtonForeground = Asset.Colors.appleButtonForeground.color
        
        public static let action = Asset.Colors.action.color
        public static let onAction = Asset.Colors.onAction.color
    }
    
    /// Defines all the fonts used in the app in a semantic way
    public enum Fonts {

        public static let index: Font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular, size: 10)
        
        public static let detail: Font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular, size: 11)
        
        public static let body: Font = UIFont.preferredFont(forTextStyle: .body, weight: .regular, size: 13)
        
        public static let headline: Font = UIFont.preferredFont(forTextStyle: .headline, weight: .semibold, size: 14)
        public static let headlineAdditional: Font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular, size: 14)
        
        public static let subtitle: Font = UIFont.preferredFont(forTextStyle: .title1, weight: .semibold, size: 16)
        
        public static let title: Font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold, size: 24)
        
        public static let screenTitle: Font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold, size: 32)

    }
}
