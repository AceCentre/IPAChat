import Foundation

final class MockUserDefaults: UserDefaults {
    var storedData: [String: Any] = [:]

    override func set(_ value: Any?, forKey defaultName: String) {
        storedData[defaultName] = value
    }

    override func object(forKey defaultName: String) -> Any? {
        return storedData[defaultName]
    }
}
