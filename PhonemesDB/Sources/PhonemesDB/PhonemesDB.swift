
@available(macOS 12.0, iOS 15.0, *)
public enum PhonemesDB: CaseIterable {
    case english_GB
    case english_US
    case french
    case spanish
    case polish
    
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
    
    public var name: String {
        switch self {
        case .english_GB: "phonemesDB.en.gb"
        case .english_US: "phonemesDB.en.us"
        case .french: "phonemesDB.fr.fr"
        case .spanish: "phonemesDB.es.es"
        case .polish: "phonemesDB.pl.pl"
        }
    }
    
    /// BCP-47 language tag
    public var identifier: String {
        switch self {
        case .english_GB: "en-GB"
        case .english_US: "en-US"
        case .french: "fr-FR"
        case .spanish: "es-ES"
        case .polish: "pl-PL"
        }
    }
    
    static public func fromIdentifier(_ identifier: String) -> PhonemesDB? {
        switch identifier {
        case "en-GB": return .english_GB
        case "en-US": return .english_US
        case "fr-FR": return .french
        case "es-ES": return .spanish
        case "pl-PL": return .polish
        default: return nil
        }
    }
}
