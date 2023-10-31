import Foundation
import PhonemesDB
@testable import IPA_Chat

final class MockPhonemesCache: PhonemesCache {
    var storedPhonemes: [Phoneme]?
    
    func set(_ phonemes: [Phoneme]) {
        storedPhonemes = phonemes
    }
    
    func get() -> [Phoneme]? {
        return storedPhonemes
    }
}
