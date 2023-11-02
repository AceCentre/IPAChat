import XCTest
@testable import IPA_Chat

enum MockSpeechCacheValue {
    case pitch(Float)
    case rate(Float)
    case languageIdentifier(String)
}

final class MockSpeechCache: SpeechCache {
    var userDefaults: UserDefaults
    
    var storedValues: [String: AnyObject] = [:]
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func set<T>(_ value: T?, key: SpeechCacheType<T>.Keys) {
        storedValues[key.rawValue] = value as? AnyObject
    }
    
    func get<T>(for key: SpeechCacheType<T>.Keys) -> SpeechCacheType<T> {
        if let value = storedValues[key.rawValue] as? MockSpeechCacheValue {
            return SpeechCacheType.value(value as? T)
        }
        return SpeechCacheType.value(nil)
    }
}
