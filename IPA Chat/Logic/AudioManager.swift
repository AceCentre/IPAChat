import SwiftUI
import AVFoundation
import SQLite

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
