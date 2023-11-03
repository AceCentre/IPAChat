import SwiftUI

struct LanguageView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    //@Binding var selectedLanguage: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("settings.language.voice.header.title".localized)) {
                    Toggle("settings.language.speak.utterance".localized, isOn: $viewModel.audioManager.shouldSpeakFullUtterance)
                }

                Section(header: Text("settings.language.select".localized)) {
                    ForEach(viewModel.languages, id: \.self) { language in
                        Button(action: {
                            viewModel.selectedLanguage = language
                        }) {
                            HStack {
                                Text(language.name.localized)
                                Spacer()
                                if viewModel.selectedLanguage == language {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("settings.language.navigation.title".localized)
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
struct LanguageView_Previews: PreviewProvider {
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
        
        return LanguageView(viewModel: vm)
    }
}
