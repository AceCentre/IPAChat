import SwiftUI
import AVFAudio

struct VoicesView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    //@Binding var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    SelectedVoiceView(viewModel: viewModel)
                }
                
                Section(header: Text("settings.voices.header.title".localized).font(.title2)) { }
 
                ForEach(viewModel.groupedVoices.keys.sorted(), id: \.self) { language in
                    Section(header: Text(language)) {
                        if let voices = viewModel.groupedVoices[language] {
                            ForEach(voices, id: \.self) { wrapper in
                                Button(action: {
                                    viewModel.audioManager.selectedVoice = wrapper.voice
                                    viewModel.selectedVoice = wrapper.voice
                                }) {
                                    HStack {
                                                                            Text(wrapper.voice.name)
                                                                            Spacer()
                                                                            if viewModel.selectedVoice == wrapper.voice {
                                                                                Image(systemName: "checkmark")
                                                                                    .foregroundColor(.blue)
                                                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("settings.voices.navigation.title".localized)
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
struct VoicesView_Previews: PreviewProvider {
    static var previews: some View {
        let speechCache = SpeechCacheImplementation(userDefaults: UserDefaults.standard)
        let phonemesCache = PhonemesCacheImplementation()
        let selectedLanguageCache = SelectedLanguageCacheImplementation()
        let vm = SettingsViewModelImplementation(
            speechCache: speechCache,
            audioManager: AudioManager(),
            selectedLanguageCache: selectedLanguageCache,
            phonemesCache: phonemesCache)
        return VoicesView(viewModel: vm)
    }
}
