@testable import IPA_Chat

class MockAudioManager: AudioManager {
    var mockPhonemeForStringResult: String?
    
    override func getPhonemeForString(selectedLanguage: String, searchString: String) -> String? {
        return mockPhonemeForStringResult
    }
}
