import Foundation

enum SpeechCacheType<T> {
    enum Keys: String {
        case pitch
        case rate
        case languageIdentifier
    }
    case value(T?)
}

protocol SpeechCache {
    var userDefaults: UserDefaults { get }
    func set<T>(_ value: T?, key: SpeechCacheType<T>.Keys)
    func get<T>(for key: SpeechCacheType<T>.Keys) -> SpeechCacheType<T>
}

struct SpeechCacheImplementation: SpeechCache {
    let userDefaults: UserDefaults
    func set<T>(_ value: T?, key: SpeechCacheType<T>.Keys) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    func get<T>(for key: SpeechCacheType<T>.Keys) -> SpeechCacheType<T> {
        if let value = userDefaults.object(forKey: key.rawValue) as? T {
            return SpeechCacheType.value(value)
        }
        return SpeechCacheType.value(nil)
    }
}
