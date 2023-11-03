import SwiftUI
import AVFAudio

struct VoiceByLanguageView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    //let selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("settings.voicebylanguage.title".localized)) {
                    let selectedLanguage = viewModel.selectedLanguage.identifier
                    if let voices = viewModel.groupedVoices[selectedLanguage] {
                        ForEach(voices, id: \.self) { wrapper in
                            Button(action: {
                                viewModel.audioManager.selectedVoice = wrapper.voice
                            }) {
                                HStack {
                                    Text(wrapper.voice.name)
                                    Spacer()
                                    if viewModel.audioManager.selectedVoice == wrapper.voice {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(
                "settings.voicebylanguage.navigation.title".localized
                +
                viewModel.selectedLanguage.name.localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

// MARK: - Previews
struct VoiceByLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        let speechCache = MockSpeechCache(userDefaults: MockUserDefaults())
        let phonemesCache = MockPhonemesCache()
        let selectedLanguageCache = MockSelectedLanguageCache()
        let audioManager = MockAudioManager()
        
        let vm = MockSettingsViewModel(
            speechCache: speechCache,
            selectedLanguageCache: selectedLanguageCache,
            phonemesCache: phonemesCache,
            audioManager: audioManager)
        
        return VoiceByLanguageView(viewModel: vm)
    }
}
