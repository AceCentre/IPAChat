
@available(macOS 12.0, iOS 15.0, *)
public enum PhonemesDB: String, CaseIterable {
    case english_GB = "English-GB"
    case english_US = "English-US"
    case french = "French"
    case spanish = "Spanish"
    case polish = "Polish"
    
    public var get: [Phoneme] {
        switch self {
        case .english_GB:
            return DataBase.english_GB_list
        case .english_US:
            return DataBase.english_US_list
        case .french:
            return DataBase.french_list
        case .spanish:
            return DataBase.spanish_list
        case .polish:
            return DataBase.polish_list
        }
    }
}
