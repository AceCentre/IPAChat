import XCTest
import Combine
@testable import IPA_Chat

final class ContentViewModelTests: XCTestCase {
    var viewModel: ContentViewModelImplementation!
    var audioManager: MockAudioManager!
    
    override func setUp() {
        super.setUp()
        audioManager = MockAudioManager()
        viewModel = ContentViewModelImplementation(audioManager: audioManager)
    }
    
    override func tearDown() {
        viewModel = nil
        audioManager = nil
        super.tearDown()
    }
    
    // MARK: - Phoneme Change Tests
    
    func testOnPhonemeChange_EnglishGB() {
        viewModel.onPhonemeChange("English-GB")
        XCTAssertEqual(viewModel.phonemes, Phonemes.english)
    }
    
    func testOnPhonemeChange_French() {
        viewModel.onPhonemeChange("French")
        XCTAssertEqual(viewModel.phonemes, Phonemes.french)
    }
    
    func testOnPhonemeChange_UnknownLanguage() {
        viewModel.onPhonemeChange("Spanish")
        // Verify that phonemes remain unchanged when an unknown language is selected
        XCTAssertEqual(viewModel.phonemes, Phonemes.english)
    }
    
    // MARK: - Search Tests
    
    func testDidTapSearch_IPAFound() {
        let searchString = "test"
        audioManager.mockPhonemeForStringResult = "[Test]"
        
        viewModel.searchQuery = searchString
        viewModel.selectedLanguage = "English-GB"
        viewModel.didTapSearch()
        XCTAssertEqual(viewModel.ipaResult, "IPA Result: [Test]")
    }
    
    func testDidTapSearch_IPANotFound() {
        let searchString = "nonexistent"
        audioManager.mockPhonemeForStringResult = nil
        
        viewModel.searchQuery = searchString
        viewModel.selectedLanguage = "French"
        viewModel.didTapSearch()
        
        XCTAssertEqual(viewModel.ipaResult, "No IPA form found")
    }
    
    // MARK: - Phonemes Handling Tests
    
    func testLoadPhonemes() {
        // Simulate saved phonemes in UserDefaults
        let encodedPhonemes = try? JSONEncoder().encode(Phonemes.english)
        UserDefaults.standard.set(encodedPhonemes, forKey: "phonemes")
        
        viewModel.loadPhonemes()
        
        XCTAssertEqual(viewModel.phonemes, Phonemes.english)
    }
}


