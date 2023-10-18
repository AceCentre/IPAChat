import SwiftUI
import AVFAudio

struct SettingsView: SwiftUI.View {
    @ObservedObject var audioManager: AudioManager
    @Binding var selectedLanguage: String
    var languages = ["English-GB", "French"]
    var groupedVoices: [String: [VoiceWrapper]] = voicesByLanguage()
    @Binding var phonemes: [Phoneme]
    
    var body: some View {
        Form {
            Toggle("Speak utterance as selected", isOn: $audioManager.shouldSpeakFullUtterance)
            
            Picker("Language", selection: $selectedLanguage) {
                ForEach(languages, id: \.self) {
                    Text($0)
                }
            }
            
            Picker("Select Voice", selection: $audioManager.selectedVoice) {
                ForEach(groupedVoices.keys.sorted(), id: \.self) { language in
                    Section(header: Text(language)) {
                        ForEach(groupedVoices[language]!, id: \.self) { wrapper in
                            Text(wrapper.voice.name).tag(wrapper.voice as AVSpeechSynthesisVoice?)
                        }
                    }
                }
            }
            
            Section(header: Text("Reorder Phonemes")) {
                List {
                    ForEach(phonemes) { phoneme in
                        Text(phoneme.symbol)
                    }
                    .onMove(perform: move)
                }
            }
        }.toolbar {
            EditButton()
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        // Move elements around
        phonemes.move(fromOffsets: source, toOffset: destination)
    }
    
}
