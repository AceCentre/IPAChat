import XCTest
import Combine
import PhonemesDB
@testable import IPA_Chat

final class ContentViewModelImplementationTests: XCTestCase {
    var viewModel: ContentViewModelImplementation!
    var phonemesCache: PhonemesCache!
    var audioManager: AudioManager!
    var selectedLanguageCache: SelectedLanguageCache!
    
    override func setUp() {
        super.setUp()
        
        // Create and inject mock dependencies
        phonemesCache = MockPhonemesCache()
        audioManager = MockAudioManager()
        selectedLanguageCache = MockSelectedLanguageCache()
        
        // Initialize the view model with mock dependencies
        viewModel = ContentViewModelImplementation(
            phonemesCache: phonemesCache,
            audioManager: audioManager,
            selectedLanguageCache: selectedLanguageCache
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewModel = nil
        phonemesCache = nil
        audioManager = nil
        selectedLanguageCache = nil
    }
    
    func testLoadPhonemes() {
        // Mock saved phonemes
        let mockPhonemes: [Phoneme] = [
            Phoneme(symbol: "a", ipaNotation: "a", type: .vowel),
            Phoneme(symbol: "b", ipaNotation: "b", type: .consonant)
        ]
        
        // Set the mock phonemes in the cache
        (phonemesCache as! MockPhonemesCache).set(mockPhonemes)
        
        // Load phonemes using the view model
        viewModel.loadPhonemes()
        
        // Check if the loaded phonemes match the mock phonemes
        XCTAssertEqual(viewModel.phonemes, mockPhonemes)
    }
    
    func testDidTapSearchWithValidQuery() {
        // Mock selected language
        let selectedLanguage = PhonemesDB.english_GB
        (selectedLanguageCache as! MockSelectedLanguageCache).set(selectedLanguage)
        
        // Mock search query
        viewModel.searchQuery = "apple"
        
        // Mock IPA result
        (audioManager as! MockAudioManager).mockPhonemeForStringResult = "ˈæpl"
        
        // Perform the search action
        viewModel.didTapSearch()
        
        // Check if IPA result and title are set correctly
        XCTAssertEqual(viewModel.ipaResult, "ˈæpl")
        XCTAssertEqual(viewModel.ipaTitle, "content.ipa.result.title".localized)
    }
    
    func testDidTapSearchWithInvalidQuery() {
        // Mock selected language
        let selectedLanguage = PhonemesDB.english_GB
        (selectedLanguageCache as! MockSelectedLanguageCache).set(selectedLanguage)
        
        // Mock search query
        viewModel.searchQuery = "xyz"
        
        // Mock IPA result to be nil (invalid query)
        (audioManager as! MockAudioManager).mockPhonemeForStringResult = nil
        
        // Perform the search action
        viewModel.didTapSearch()
        
        // Check if the title reflects the error
        XCTAssertEqual(viewModel.ipaTitle, "content.ipa.result.error".localized)
    }
}
