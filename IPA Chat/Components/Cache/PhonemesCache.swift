import Foundation
import PhonemesDB

// MARK: - PhonemesCache Protocol
protocol PhonemesCache {
    func set(_ phonemes: [Phoneme])
    func get() -> [Phoneme]?
}

// MARK: - PhonemesCache Implementation
struct PhonemesCacheImplementation: PhonemesCache {
    private enum Keys: String {
        case phonemes
    }
    
    func set(_ phonemes: [Phoneme]) {
        guard let encoded = try? JSONEncoder().encode(phonemes) else {
            print("JSONEncoder can't encode Phonemes!")
            return
        }
        UserDefaults.standard.set(encoded, forKey: Keys.phonemes.rawValue)
    }
    
    func get() -> [Phoneme]? {
        guard let savedPhonemes = UserDefaults.standard.object(forKey: Keys.phonemes.rawValue) as? Data,
              let decodedPhonemes = try? JSONDecoder().decode([Phoneme].self, from: savedPhonemes) else {
            return nil
        }
        return decodedPhonemes
    }
}
