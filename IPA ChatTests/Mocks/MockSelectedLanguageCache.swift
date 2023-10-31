import XCTest
@testable import IPA_Chat
import PhonemesDB

final class MockSelectedLanguageCache: SelectedLanguageCache {
    var selectedLanguage: PhonemesDB?
    
    func set(_ language: PhonemesDB) {
        selectedLanguage = language
    }
    
    func get() -> PhonemesDB? {
        return selectedLanguage
    }
}
