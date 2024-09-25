import Foundation
import AVFoundation
import PhonemesDB

class MockSettingsViewModel: SettingsViewModel {
    var speechCache: SpeechCache
    var selectedLanguageCache: SelectedLanguageCache
    var phonemesCache: PhonemesCache
    var audioManager: AudioManager
    var languages: [PhonemesDB] = []
    var groupedVoices: [String: [VoiceWrapper]] = [:]
    var pitch: Float = 1.0
    var rate: Float = 1.0
    var selectedVoice: AVSpeechSynthesisVoice?
    var shouldShowRequestPersonalVoiceAuthorization: Bool = false
    var selectedLanguage: PhonemesDB = .english_GB
    
    var phonemes: [Phoneme] {
        return phonemesCache.get() ?? []
    }

    init(speechCache: SpeechCache, selectedLanguageCache: SelectedLanguageCache, phonemesCache: PhonemesCache, audioManager: AudioManager) {
        self.speechCache = speechCache
        self.selectedLanguageCache = selectedLanguageCache
        self.phonemesCache = phonemesCache
        self.audioManager = audioManager

        languages = [.english_GB, .french]
        selectedVoice = AVSpeechSynthesisVoice(language: "en-US")
        groupedVoices = ["English": [VoiceWrapper(voice: selectedVoice!)]]
    }
}

