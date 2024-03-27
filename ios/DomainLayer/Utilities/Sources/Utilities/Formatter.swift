//
//  Created by Petr Chmelar on 21/02/2020.
//  Copyright © 2020 Matee. All rights reserved.
//

import Foundation

/// Helper for defining global formatters
/// - It is expensive to recreate formatters everytime you need them, so it is a good idea to hold them here
/// - Idea taken from [ChibiCode](http://www.chibicode.org/?p=41)
public struct Formatter {
    
    public enum Date {
        public static let iso8601 = ISO8601DateFormatter()
        public static let `default` = createDateFormatter()
        public static let timeOnly = createDateFormatter(dateStyle: .none, timeStyle: .short)
    }
    
    public enum DateComponents {
        public static let `default` = createDateComponentsFormatter()
        public static let timer = createDateComponentsFormatter(
            allowedUnits: [.hour, .minute, .second],
            unitsStyle: .positional,
            zeroFormattingBehaviour: .pad
        )
    }
    
    public enum Number {
        public static let `default` = createNumberFormatter()
    }
    
    /// Creates a DateFormatter based on a given date and time styles.
    private static func createDateFormatter(
        dateStyle: DateFormatter.Style = .medium,
        timeStyle: DateFormatter.Style = .short
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
    
    /// Creates a DateFormatter based on a given template.
    private static func createDateFormatter(template: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: formatter.locale)
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
    
    /// Creates a DateFormatter based on a given date format.
    /// - Please note that this conversion does not respect user's locale/preferences.
    private static func createDateFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }
    
    /// Creates a `DateComponentsFormatter` based on given parameters.
    private static func createDateComponentsFormatter(
        allowedUnits: NSCalendar.Unit = [.hour, .minute],
        unitsStyle: DateComponentsFormatter.UnitsStyle = .abbreviated,
        zeroFormattingBehaviour: DateComponentsFormatter.ZeroFormattingBehavior = .default
    ) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.unitsStyle = unitsStyle
        formatter.zeroFormattingBehavior = zeroFormattingBehaviour
        return formatter
    }
    
    /// Creates a NumberFormatter based on a given number style.
    private static func createNumberFormatter(
        numberStyle: NumberFormatter.Style = .decimal,
        separator: String? = nil
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        formatter.groupingSeparator = separator
        return formatter
    }
}
