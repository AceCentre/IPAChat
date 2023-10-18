import SwiftUI
import AVFAudio

struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @Binding var selectedLanguage: String
    @Binding var phonemes: [Phoneme]
    
    var body: some View {
        Form {
            Toggle("Speak utterance as selected", isOn: $viewModel.audioManager.shouldSpeakFullUtterance)
            
            Picker("Language", selection: $selectedLanguage) {
                ForEach(viewModel.languages, id: \.self) {
                    Text($0)
                }
            }
            
            Picker("Select Voice", selection: $viewModel.audioManager.selectedVoice) {
                ForEach(viewModel.groupedVoices.keys.sorted(), id: \.self) { language in
                    Section(header: Text(language)) {
                        ForEach(viewModel.groupedVoices[language]!, id: \.self) { wrapper in
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

// MARK: - Previews
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SettingsViewModelImplementation(audioManager: AudioManager())
        @State var selectedLanguage = "test language"
        @State var phonemes = [Phoneme(symbol: "test", ipaNotation: "test", type: .nasal)]
        
        SettingsView(
            viewModel: vm,
            selectedLanguage: $selectedLanguage,
            phonemes: $phonemes)
    }
}
