import SwiftUI
import AVFoundation
import SQLite

struct VoiceWrapper: Hashable {
    let id: UUID
    let voice: AVSpeechSynthesisVoice
    
    init(voice: AVSpeechSynthesisVoice) {
        self.id = UUID()
        self.voice = voice
    }
}
