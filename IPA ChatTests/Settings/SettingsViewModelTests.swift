import XCTest
import Combine
@testable import IPA_Chat

final class SettingsViewModelTests: XCTestCase {
    var viewModel: SettingsViewModelImplementation!
    var audioManager: MockAudioManager!
    
    override func setUp() {
        super.setUp()
        audioManager = MockAudioManager()
        viewModel = SettingsViewModelImplementation(audioManager: audioManager)
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
        let expectedLanguages = ["English-GB", "French"]
        XCTAssertEqual(viewModel.languages, expectedLanguages)
    }
}
