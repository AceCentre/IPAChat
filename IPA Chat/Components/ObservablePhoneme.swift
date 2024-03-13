import Foundation
import SwiftUI
import PhonemesDB

// Manually implement Codable to ignore the `color` property
enum CodingKeys: String, CodingKey {
    case id, symbol, ipaNotation, type, x, y
}

// The observable object
class ObservablePhoneme: ObservableObject {
    @Published var phoneme: Phoneme
    
    init(phoneme: Phoneme) {
        self.phoneme = phoneme
    }
}
