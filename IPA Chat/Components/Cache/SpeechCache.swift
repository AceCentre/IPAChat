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
    func set<T>(_ value: T?, key: SpeechCacheType<T>.Keys)
    func get<T>(for key: SpeechCacheType<T>.Keys) -> SpeechCacheType<T>
}

struct SpeechCacheImplementation: SpeechCache {
    func set<T>(_ value: T?, key: SpeechCacheType<T>.Keys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func get<T>(for key: SpeechCacheType<T>.Keys) -> SpeechCacheType<T> {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) as? T {
            return SpeechCacheType.value(value)
        }
        return SpeechCacheType.value(nil)
    }
}
