import Foundation
import PhonemesDB

final class MockPhonemesCache: PhonemesCache {
    var storedPhonemes: [Phoneme]?
    
    func set(_ phonemes: [Phoneme]) {
        storedPhonemes = phonemes
    }
    
    func get() -> [Phoneme]? {
        return storedPhonemes
    }
}
