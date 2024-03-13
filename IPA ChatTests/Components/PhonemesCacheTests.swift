import XCTest
@testable import PhonemesDB
@testable import IPA_Chat

final class PhonemesCacheTests: XCTestCase {
    var phonemesCache: PhonemesCache!
    
    override func setUp() {
        super.setUp()
        phonemesCache = PhonemesCacheImplementation()
    }

    override func tearDown() {
        phonemesCache = nil
        super.tearDown()
    }

    func testSetAndGetPhonemes() {
        // Arrange
        let phoneme1 = Phoneme(symbol: "1", ipaNotation: "1", type: .consonant)
        let phoneme2 = Phoneme(symbol: "2", ipaNotation: "2", type: .consonant)
        let phonemes = [phoneme1, phoneme2]

        // Act
        phonemesCache.set(phonemes)
        let retrievedPhonemes = phonemesCache.get()

        // Assert
        XCTAssertEqual(retrievedPhonemes, phonemes)
    }

    func testGetPhonemesWhenEmpty() {
        // Act
        let retrievedPhonemes = phonemesCache.get()

        // Assert
        XCTAssertNil(retrievedPhonemes)
    }
}
