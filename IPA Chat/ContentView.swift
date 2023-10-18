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

func voicesByLanguage() -> [String: [VoiceWrapper]] {
    let voices = AVSpeechSynthesisVoice.speechVoices()
    var voiceDict = [String: [VoiceWrapper]]()
    
    for voice in voices {
        let wrapper = VoiceWrapper(voice: voice)
        let languageCode = voice.language
        if voiceDict[languageCode] != nil {
            voiceDict[languageCode]!.append(wrapper)
        } else {
            voiceDict[languageCode] = [wrapper]
        }
    }
    
    return voiceDict
}


// Manually implement Codable to ignore the `color` property
enum CodingKeys: String, CodingKey {
    case id, symbol, ipaNotation, type, x, y
}

enum PhonemeType: Codable {
    case vowel, consonant, diphthong, stress, pause, semivowel, nasal
}

struct Phoneme: Identifiable, Codable {
    let id: UUID  // Make this immutable
    let symbol: String
    let ipaNotation: String
    let type: PhonemeType
    var x: CGFloat
    var y: CGFloat
    
    init(id: UUID? = nil, symbol: String, ipaNotation: String, type: PhonemeType, x: CGFloat = 0, y: CGFloat = 0) {
        self.id = id ?? UUID()
        self.symbol = symbol
        self.ipaNotation = ipaNotation
        self.type = type
        self.x = x
        self.y = y
    }
    
    var color: Color {
        switch type {
        case .vowel: return Color.red
        case .consonant: return Color.blue
        case .diphthong: return Color.green
        case .stress: return Color.purple
        case .semivowel: return Color.brown
        case .nasal: return Color.gray
        case .pause: return Color.pink
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, ipaNotation, type, x, y
    }
}


// The observable object
class ObservablePhoneme: ObservableObject {
    @Published var phoneme: Phoneme
    
    init(phoneme: Phoneme) {
        self.phoneme = phoneme
    }
}

class AudioManager: ObservableObject {
    private var synthesizer = AVSpeechSynthesizer()
    public var phonemeString = NSMutableAttributedString(string: "")
    @Published var currentPhonemeSequence: String = ""
    @Published var isBabbleModeOn: Bool = false
    @Published var shouldSpeakFullUtterance: Bool = true  // Add this for the setting
    @Published var selectedVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: "en-GB")
    var db: Connection!
    
    init () {
        // Initialize the audio session to play sound even in silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
        connectToDB()
    }
    
    func connectToDB() {
        if let sourceURL = Bundle.main.url(forResource: "ipa-dict", withExtension: "db") {
            do {
                db = try Connection(sourceURL.path)
            } catch {
                print("Connection failed: \(error)")
            }
        }
    }
    
    func getPhonemeForString(selectedLanguage: String, searchString: String) -> String? {
        guard let db = self.db else {
            print("Database not initialized.")
            return nil
        }
        
        let tableName = selectedLanguage == "French" ? "fr_FR" : "en_UK"
        let ipa = Expression<String>("ipa")
        let string = Expression<String>("string")
        let table = Table(tableName)
        
        do {
            let query = table.select(ipa).filter(string == searchString)
            for row in try db.prepare(query) {
                let ipaCol = row[ipa]
                print("Found IPA: \(ipaCol)")
                return ipaCol
            }
        } catch {
            print("Select failed: \(error)")
        }
        
        print("No IPA found")
        return nil
    }
    
    func appendPhoneme(_ phoneme: Phoneme) {
        let str = "\(phoneme.symbol)" // space for separation
        let newPhonemeString = NSMutableAttributedString(string: str)
        let range = NSRange(location: 0, length: str.count)
        newPhonemeString.addAttribute(.init(AVSpeechSynthesisIPANotationAttribute), value: phoneme.ipaNotation, range: range)
        
        // Speak just the new phoneme if Babble Mode is on
        if isBabbleModeOn {
            let utterance = AVSpeechUtterance(attributedString: newPhonemeString)
            utterance.voice = selectedVoice
            synthesizer.speak(utterance)
            return
        }
        
        // Otherwise, append the new phoneme to the sequence and optionally speak the full sequence
        phonemeString.append(newPhonemeString)
        currentPhonemeSequence += "\(phoneme.symbol)"
        
        if shouldSpeakFullUtterance {
            let utterance = AVSpeechUtterance(attributedString: phonemeString)
            utterance.voice = selectedVoice
            synthesizer.speak(utterance)
        }
    }
    
    func speakCurrentSequence() {
        // Use the phonemeString with IPA notation to speak the sequence
        let utterance = AVSpeechUtterance(attributedString: phonemeString)
        utterance.voice = selectedVoice
        if let voice = utterance.voice {
            print("Voice Name: \(voice.name)")
            print("Voice Language: \(voice.language)")
            print("Voice Quality: \(voice.quality.rawValue)")
        } else {
            print("No voice set for the utterance.")
        }
        
        synthesizer.speak(utterance)
    }
    
    func clearSequence() {
        currentPhonemeSequence = ""
        phonemeString = NSMutableAttributedString(string: "")
    }
    
    func toggleButton() {
        // Perform the toggle logic here.
        // For example, if you have a boolean property called `isBabbleModeOn`
        isBabbleModeOn.toggle()
    }
}

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

