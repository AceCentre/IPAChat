import SwiftUI
import PhonemesDB

struct PhonemesView<ViewModel>: View where ViewModel: SettingsViewModel {
    @ObservedObject var viewModel: ViewModel
    @State private var observablePhonemes: [ObservablePhoneme] = []
    @State private var selectedPhoneme: ObservablePhoneme?
    @State private var showingCustomizationSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(observablePhonemes) { observablePhoneme in
                    Button(action: {
                        selectedPhoneme = observablePhoneme
                        // Ensure the phoneme is set before presenting the sheet
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showingCustomizationSheet = true
                        }
                    }) {
                        HStack {
                            if let customImage = observablePhoneme.customImage {
                                Image(uiImage: customImage)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            } else if let customText = observablePhoneme.customText {
                                Text(customText)
                            } else {
                                Text(observablePhoneme.phoneme.symbol)
                            }
                            Spacer()
                            Rectangle()
                                .fill(observablePhoneme.color)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .navigationTitle("Phonemes")
            .sheet(isPresented: $showingCustomizationSheet) {
                if let phoneme = selectedPhoneme {
                    PhonemeCustomizationView(observablePhoneme: .constant(phoneme))
                } else {
                    // Provide a fallback view to prevent a blank screen
                    Text("No phoneme selected")
                }
            }
            .onAppear {
                // Initialize observablePhonemes from the existing phoneme list
                observablePhonemes = viewModel.phonemes.map { ObservablePhoneme(phoneme: $0) }
            }
        }
    }
}

// MARK: - Previews
struct PhonemesView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePhonemes: [Phoneme] = [
            Phoneme(symbol: "A", ipaNotation: "test", type: .nasal),
            Phoneme(symbol: "B", ipaNotation: "test", type: .nasal),
            Phoneme(symbol: "C", ipaNotation: "test", type: .nasal),
        ]
        
        let speechCache = MockSpeechCache(userDefaults: MockUserDefaults())
        let phonemesCache = MockPhonemesCache()
        phonemesCache.set(samplePhonemes)  // Pre-populate the mock cache with sample phonemes
        let selectedLanguageCache = MockSelectedLanguageCache()
        let audioManager = MockAudioManager()
        
        let vm = MockSettingsViewModel(
            speechCache: speechCache,
            selectedLanguageCache: selectedLanguageCache,
            phonemesCache: phonemesCache,
            audioManager: audioManager)
        
        return PhonemesView(viewModel: vm)
    }
}

