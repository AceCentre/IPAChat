//
//  Helpers.swift
//  Echo
//
//  Created by Gavin Henderson on 03/10/2023.
//

import Foundation
import SwiftUI

func getLanguageAndRegion(_ givenLocale: String) -> String {
    let currentLocale: Locale = .current
    return currentLocale.localizedString(forIdentifier: givenLocale) ?? "Unknown"
}

func getLanguage(_ givenLocale: String) -> String {
    let currentLocale: Locale = .current
    return currentLocale.localizedString(forLanguageCode: givenLocale) ?? "Unknown"
}

