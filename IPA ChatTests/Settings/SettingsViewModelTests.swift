import XCTest
import Combine
import PhonemesDB
@testable import IPA_Chat

final class SettingsViewModelTests: XCTestCase {
    var viewModel: SettingsViewModelImplementation!
    var audioManager: MockAudioManager!
    var phonemesCache: MockPhonemesCache!
    var selectedLanguageCache: MockSelectedLanguageCache!
    var speechCache: MockSpeechCache!
    
    override func setUp() {
        super.setUp()
        audioManager = MockAudioManager()
        
        viewModel = SettingsViewModelImplementation(
            speechCache: speechCache,
            audioManager: audioManager,
            selectedLanguageCache: selectedLanguageCache,
            phonemesCache: phonemesCache)
    }
    
    override func tearDown() {
        viewModel = nil
        audioManager = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Verify that the audioManager is properly initialized
        XCTAssertTrue(viewModel.audioManager === audioManager)
    }
    
    // MARK: - Languages Tests
    
    func testLanguages() {
        let expectedLanguages = PhonemesDB.allCases
        XCTAssertEqual(viewModel.languages, expectedLanguages)
    }
}
