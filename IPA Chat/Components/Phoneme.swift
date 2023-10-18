import Foundation
import SwiftUI

// Manually implement Codable to ignore the `color` property
enum CodingKeys: String, CodingKey {
    case id, symbol, ipaNotation, type, x, y
}

enum PhonemeType: Codable {
    case vowel, consonant, diphthong, stress, pause, semivowel, nasal
}

struct Phoneme: Identifiable, Codable, Equatable {
    let id: UUID  // Make this immutable
    let symbol: String
    let ipaNotation: String
    let type: PhonemeType
    var x: CGFloat
    var y: CGFloat
    
    init(id: UUID? = nil, symbol: String, ipaNotation: String, type: PhonemeType, x: CGFloat = 0, y: CGFloat = 0) {
        self.id = id ?? UUID()
        self.symbol = symbol
        self.ipaNotation = ipaNotation
        self.type = type
        self.x = x
        self.y = y
    }
    
    var color: Color {
        switch type {
        case .vowel: return Color.red
        case .consonant: return Color.blue
        case .diphthong: return Color.green
        case .stress: return Color.purple
        case .semivowel: return Color.brown
        case .nasal: return Color.gray
        case .pause: return Color.pink
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, ipaNotation, type, x, y
    }
}


// The observable object
class ObservablePhoneme: ObservableObject {
    @Published var phoneme: Phoneme
    
    init(phoneme: Phoneme) {
        self.phoneme = phoneme
    }
}
