import XCTest
import PhonemesDB
@testable import IPA_Chat

final class SpeechCacheImplementationTests: XCTestCase {
    var speechCache: SpeechCacheImplementation!
    var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()

        mockUserDefaults = MockUserDefaults()
        speechCache = SpeechCacheImplementation(userDefaults: mockUserDefaults)
    }

    override func tearDown() {
        super.tearDown()

        mockUserDefaults = nil
        speechCache = nil
    }

    func testSetAndGet() {
        let valueToSet: Float = 0.5

        // Set a value in the cache
        speechCache.set(valueToSet, key: .pitch)

        // Get the value from the cache
        let retrievedValue: SpeechCacheType<Float> = speechCache.get(for: .pitch)

        // Assert that the retrieved value matches the one we set
        if case .value(let cachedValue) = retrievedValue {
            XCTAssertEqual(cachedValue!, valueToSet, accuracy: 0.001)
        } else {
            XCTFail("Failed to retrieve value from cache")
        }
    }

    func testGetNonExistentValue() {
        // Attempt to get a value that does not exist in the cache
        let retrievedValue: SpeechCacheType<Float> = speechCache.get(for: .pitch)

        // Assert that the retrieved value is nil
        if case .value(let cachedValue) = retrievedValue {
            XCTAssertNil(cachedValue)
        } else {
            XCTFail("Failed to retrieve value from cache")
        }
    }
}
