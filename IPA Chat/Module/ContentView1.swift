import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var audioManager = AudioManager()
    @State var isEditMode: Bool = false
    @State var selectedLanguage: String = "English-GB"
    @State var phonemes: [Phoneme] = Phonemes.english
    @State var currentPhonemes: [Phoneme] = Phonemes.english
    @State private var ipaDictionary: [String: String] = [:]
    @State private var searchQuery: String = ""
    @State private var searchResult: String?
    @State private var showingSearchSheet = false
    @State private var ipaResult: String? = nil
    
    
    struct Phonemes {
        static let english: [Phoneme] = [
            Phoneme(symbol: "iː", ipaNotation: "iː", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ɪ", ipaNotation: "ɪ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "e", ipaNotation: "e", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "æ", ipaNotation: "æ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "aː", ipaNotation: "aː", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ɒ", ipaNotation: "ɒ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ɔː", ipaNotation: "ɔː", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ʊ", ipaNotation: "ʊ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "uː", ipaNotation: "uː", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ɜː", ipaNotation: "ɜː", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ə", ipaNotation: "ə", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "eɪ", ipaNotation: "eɪ", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "aɪ", ipaNotation: "aɪ", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "ɔɪ", ipaNotation: "ɔɪ", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "aʊ", ipaNotation: "aʊ", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "oʊ", ipaNotation: "oʊ", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "ɪə", ipaNotation: "ɪə", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "eə", ipaNotation: "eə", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "ʊə", ipaNotation: "ʊə", type: .diphthong, x: 0, y: 0),
            Phoneme(symbol: "p", ipaNotation: "p", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "b", ipaNotation: "b", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "t", ipaNotation: "t", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "d", ipaNotation: "d", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "k", ipaNotation: "k", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "g", ipaNotation: "g", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ʧ", ipaNotation: "ʧ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ʤ", ipaNotation: "ʤ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "f", ipaNotation: "f", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "v", ipaNotation: "v", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "θ", ipaNotation: "θ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ð", ipaNotation: "ð", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "s", ipaNotation: "s", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "z", ipaNotation: "z", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ʃ", ipaNotation: "ʃ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ʒ", ipaNotation: "ʒ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "h", ipaNotation: "h", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "m", ipaNotation: "m", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "n", ipaNotation: "n", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ŋ", ipaNotation: "ŋ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "l", ipaNotation: "l", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "r", ipaNotation: "r", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "j", ipaNotation: "j", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "w", ipaNotation: "w", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: ",", ipaNotation: ",", type: .stress, x: 0, y: 0),
            Phoneme(symbol: "ˈ", ipaNotation: "ˈ", type: .stress, x: 0, y: 0),
            Phoneme(symbol: "‖", ipaNotation: "‖", type: .pause, x: 0, y: 0),
            Phoneme(symbol: "‖‖", ipaNotation: "‖‖", type: .pause,  x: 0, y: 0)
        ]
        static let french: [Phoneme] = [
            Phoneme(symbol: "i", ipaNotation: "i", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "e", ipaNotation: "e", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ɛ", ipaNotation: "ɛ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "a", ipaNotation: "a", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ɑ", ipaNotation: "ɑ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "o", ipaNotation: "o", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ɔ", ipaNotation: "ɔ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "u", ipaNotation: "u", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "y", ipaNotation: "y", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "ø", ipaNotation: "ø", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "œ", ipaNotation: "œ", type: .vowel, x: 0, y: 0),
            Phoneme(symbol: "w", ipaNotation: "w", type: .semivowel, x: 0, y: 0),
            Phoneme(symbol: "ɥ", ipaNotation: "ɥ", type: .semivowel, x: 0, y: 0),
            Phoneme(symbol: "j", ipaNotation: "j", type: .semivowel, x: 0, y: 0),
            Phoneme(symbol: "p", ipaNotation: "p", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "b", ipaNotation: "b", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "t", ipaNotation: "t", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "d", ipaNotation: "d", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "k", ipaNotation: "k", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "g", ipaNotation: "g", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "f", ipaNotation: "f", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "v", ipaNotation: "v", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "s", ipaNotation: "s", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "z", ipaNotation: "z", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ʃ", ipaNotation: "ʃ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ʒ", ipaNotation: "ʒ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "m", ipaNotation: "m", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "n", ipaNotation: "n", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ɲ", ipaNotation: "ɲ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ŋ", ipaNotation: "ŋ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "l", ipaNotation: "l", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ʁ", ipaNotation: "ʁ", type: .consonant, x: 0, y: 0),
            Phoneme(symbol: "ɑ̃", ipaNotation: "ɑ̃", type: .nasal, x: 0, y: 0),
            Phoneme(symbol: "ɛ̃", ipaNotation: "ɛ̃", type: .nasal, x: 0, y: 0),
            Phoneme(symbol: "œ̃", ipaNotation: "œ̃", type: .nasal, x: 0, y: 0),
            Phoneme(symbol: "ɔ̃", ipaNotation: "ɔ̃", type: .nasal, x: 0, y: 0)]
    }
    
    init() {
        loadPhonemes()
    }
    
    
    func savePhonemes() {
        if let encoded = try? JSONEncoder().encode(phonemes) {
            UserDefaults.standard.set(encoded, forKey: "phonemes")
        }
    }
    
    func loadPhonemes() {
        if let savedPhonemes = UserDefaults.standard.object(forKey: "phonemes") as? Data,
           let decodedPhonemes = try? JSONDecoder().decode([Phoneme].self, from: savedPhonemes) {
            self.phonemes = decodedPhonemes
        }
    }
    
    
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
                            ForEach(phonemes) { phoneme in
                                Button(action: {
                                    audioManager.appendPhoneme(phoneme)
                                }) {
                                    Text(phoneme.symbol)
                                        .frame(width: 70, height: 70)
                                        .background(phoneme.color)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .offset(x: phoneme.x, y: phoneme.y) // Offset the button
                            }
                            
                            
                        }
                    }
                    .padding()
                    
                    // Extended message bar
                    TextField("Current Sequence", text: $audioManager.currentPhonemeSequence)
                        .disabled(true)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    //IPA Search
                    if let result = ipaResult {
                        Text("IPA Result: \(result)")
                            .padding()
                    }
                    
                    // Buttons for Speak, Clear, Babble Mode, and Settings
                    HStack {
                        // Left-aligned buttons (Speak and Clear)
                        Button(action: {
                            audioManager.speakCurrentSequence()
                        }) {
                            Image(systemName: "speaker.2.fill")
                        }
                        .padding()
                        
                        Button(action: {
                            audioManager.clearSequence()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .padding()
                        
                        Spacer() // Pushes the buttons to the opposite ends
                        
                        // Right-aligned buttons (Babble Mode and Settings)
                        Button(action: {
                            self.showingSearchSheet = true
                        }) {
                            Image(systemName: "magnifyingglass.circle.fill")
                        }
                        .padding()
                        Button(action: {
                            audioManager.toggleButton()
                        }) {
                            Image(systemName: "ellipsis.circle.fill")
                                .foregroundColor(audioManager.isBabbleModeOn ? .green : .gray)
                        }
                        .padding()
                        
                        NavigationLink(destination: SettingsView(audioManager: audioManager, selectedLanguage: $selectedLanguage, phonemes: $phonemes)) {
                            Image(systemName: "gearshape.fill")
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $showingSearchSheet) {
                    VStack {
                        Text("Search for a word")
                        TextField("Enter the word to find its IPA form.", text: $searchQuery)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button("Search") {
                            let lowercasedQuery = searchQuery.lowercased()
                            if let ipaForm = audioManager.getPhonemeForString(selectedLanguage: selectedLanguage, searchString: lowercasedQuery) {
                                self.ipaResult = ipaForm
                            } else {
                                self.ipaResult = "No IPA form found"
                            }
                            self.showingSearchSheet = false
                        }
                        .padding()
                    }
                    .padding()
                }
                .padding(.horizontal)  // Add some horizontal padding to the VStack
            }.onChange(of: selectedLanguage) { newValue in
                print("Language changed to: \(String(describing: newValue))")
                switch newValue {
                case "English-GB":
                    self.phonemes = Phonemes.english
                case "French":
                    self.phonemes = Phonemes.french
                default:
                    print("Unknown language")
                }
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
