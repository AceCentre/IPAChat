import SwiftUI
import AVFoundation
import SQLite

func voicesByLanguage() -> [String: [VoiceWrapper]] {
    let voices = AVSpeechSynthesisVoice.speechVoices()
    var voiceDict = [String: [VoiceWrapper]]()
    
    for voice in voices {
        let wrapper = VoiceWrapper(voice: voice)
        let languageCode = voice.language
        if voiceDict[languageCode] != nil {
            voiceDict[languageCode]!.append(wrapper)
        } else {
            voiceDict[languageCode] = [wrapper]
        }
    }
    
    return voiceDict
}
