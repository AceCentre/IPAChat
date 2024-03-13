import Foundation
import PhonemesDB

// MARK: - SelectedLanguageCache Protocol
protocol SelectedLanguageCache {
    func set(_ language: PhonemesDB)
    func get() -> PhonemesDB?
}

// MARK: - SelectedLanguageCache Implementation
struct SelectedLanguageCacheImplementation: SelectedLanguageCache {
    private enum Keys: String {
        case selectedPhoneme
    }
    
    func set(_ language: PhonemesDB) {
        UserDefaults.standard.setValue(language.identifier, forKey: Keys.selectedPhoneme.rawValue)
    }
    
    func get() -> PhonemesDB? {
        guard let savedLanguage = UserDefaults.standard.object(forKey: Keys.selectedPhoneme.rawValue) as? String else {
            return nil
        }
        
        guard let phoneme = PhonemesDB.fromIdentifier(savedLanguage) else { return nil }
        
        return phoneme
    }
}

