import XCTest
import PhonemesDB
@testable import IPA_Chat

final class SelectedLanguageCacheTests: XCTestCase {
    var languageCache: SelectedLanguageCache!
    
    override func setUp() {
        super.setUp()
        languageCache = SelectedLanguageCacheImplementation()
    }

    override func tearDown() {
        languageCache = nil
        super.tearDown()
    }

    func testSetAndGetLanguage() {
        // Arrange
        let language = PhonemesDB.english_GB

        // Act
        languageCache.set(language)
        let retrievedLanguage = languageCache.get()

        // Assert
        XCTAssertEqual(retrievedLanguage, language)
    }

    func testGetLanguageWhenEmpty() {
        // Act
        let retrievedLanguage = languageCache.get()

        // Assert
        XCTAssertNil(retrievedLanguage)
    }
}
