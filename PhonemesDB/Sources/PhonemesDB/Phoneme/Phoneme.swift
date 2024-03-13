import Foundation
import SwiftUI

@available(macOS 12.0, iOS 15.0, *)
public struct Phoneme: Identifiable, Codable, Equatable {
    public let id: UUID  // Make this immutable
    public let symbol: String
    public let ipaNotation: String
    public let type: PhonemeType
    public var x: CGFloat
    public var y: CGFloat
    
    public init(id: UUID? = nil, symbol: String, ipaNotation: String, type: PhonemeType, x: CGFloat = 0, y: CGFloat = 0) {
        self.id = id ?? UUID()
        self.symbol = symbol
        self.ipaNotation = ipaNotation
        self.type = type
        self.x = x
        self.y = y
    }
    
    public var color: Color {
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
    
    public enum CodingKeys: String, CodingKey {
        case id, symbol, ipaNotation, type, x, y
    }
}
