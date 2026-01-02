public struct LanguageMap {
    public static let mappings: [String: String] = [
        "pt-BR": "pt"
    ]

    public static func map(_ code: String) -> String {
        mappings[code] ?? code
    }
}
