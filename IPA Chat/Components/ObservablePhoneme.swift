import Foundation
import SwiftUI
import PhonemesDB

// Manually implement Codable to ignore the `color` property
enum CodingKeys: String, CodingKey {
    case id, symbol, ipaNotation, type, x, y
}


// The observable object for Phoneme, including customization properties
class ObservablePhoneme: ObservableObject, Identifiable {
    @Published var phoneme: Phoneme
    @Published var color: Color
    @Published var customText: String? = nil
    @Published var customImage: UIImage? = nil

    var id: UUID {
        phoneme.id
    }
    
    init(phoneme: Phoneme) {
        self.phoneme = phoneme
        self.color = ObservablePhoneme.defaultColor(for: phoneme.type)
    }
    
    // Set default color based on Phoneme type
    private static func defaultColor(for type: PhonemeType) -> Color {
        switch type {
        case .nasal:
            return .green
        case .vowel:
            return .red
        case .diphthong:
            return .orange
        case .consonant:
            return .yellow
        case .stress:
            return .pink
        case .semivowel:
            return .brown
        // Add more cases as needed based on your phoneme types
        default:
            return .blue  // Fallback color if type is not recognized
        }
    }
}
