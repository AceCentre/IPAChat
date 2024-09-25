import SwiftUI
import PhonemesDB

struct ContentView<ViewModel, Audio>: View where ViewModel: ContentViewModel, Audio: AudioManager {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var audioManager: Audio
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var isEditMode: Bool = false
    @State var currentPhonemes: [Phoneme] = PhonemesDB.english_GB.get
    @State private var observablePhonemes: [ObservablePhoneme] = []
    @State private var ipaDictionary: [String: String] = [:]
    @State private var searchResult: String?
    @State private var showingSearchSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    // Main Content: ScrollView with LazyVGrid
                    ScrollView {
                        // To layout in 4 columns for portrait or 7 columns for landscape
                        LazyVGrid(columns: geometry.size.width > geometry.size.height ?
                                  Array(repeating: GridItem(.flexible()), count: 7) :
                                    Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                            ForEach(observablePhonemes) { observablePhoneme in
                                ContentPhonemeButtonView(
                                    viewModel: viewModel,
                                    audioManager: audioManager,
                                    observablePhoneme: observablePhoneme
                                )
                            }
                        }
                    }
                    .padding()
                    
                    // Extended message bar
                    TextField("content.sequence.title".localized, text: $audioManager.currentPhonemeSequence)
                        .disabled(true)
                        .padding()
                    //.frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    //IPA Search
                    HStack {
                        Text(viewModel.ipaTitle ?? "")
                        Text(viewModel.ipaResult ?? "")
                            .bold()
                    }
                    
                    // Buttons for Speak, Clear, Babble Mode, and Settings
                    ContentButtonBarView(
                        viewModel: viewModel, audioManager: audioManager,
                        showingSearchSheet: $showingSearchSheet)
                }
                .onAppear {
                    // Trigger any actions needed when the view appears
                    viewModel.viewDidAppear()
                    
                    // Convert Phoneme objects to ObservablePhoneme
                    observablePhonemes = viewModel.phonemes.map { ObservablePhoneme(phoneme: $0) }
                }
                .sheet(isPresented: $showingSearchSheet) {
                    ContentSearchView(
                        viewModel: viewModel,
                        showingSearchSheet: $showingSearchSheet)
                }
                .padding(.horizontal)  // Add some horizontal padding to the VStack
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let audioManager = MockAudioManager()
        let phonemesCache = MockPhonemesCache()
        let selectedLanguageCache = MockSelectedLanguageCache()
        
        let vm = MockContentViewModel(
            phonemesCache: phonemesCache,
            audioManager: audioManager,
            selectedLanguageCache: selectedLanguageCache)
        
        ContentView(viewModel: vm, audioManager: audioManager)
    }
}
