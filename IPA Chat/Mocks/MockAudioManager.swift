import Foundation

final class MockAudioManager: AudioManager {
    var mockPhonemeForStringResult: String?
    
    override func getPhonemeForString(selectedLanguage: String, searchString: String) -> String? {
        return mockPhonemeForStringResult
    }
}
