import SwiftUI
import AVFoundation
import SQLite

enum SortVoices {
    private static let voices = AVSpeechSynthesisVoice.speechVoices()
    private static var voiceDict = [String: [VoiceWrapper]]()
    
    static func sortByLanguage() -> [String: [VoiceWrapper]] {
        return voices.map { VoiceWrapper(voice: $0) }
            .reduce(into: [String: [VoiceWrapper]]()) { dict, wrapper in
                let languageCode = wrapper.voice.language
                dict[languageCode, default: []].append(wrapper)
            }
    }
}
