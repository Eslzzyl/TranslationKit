public struct LanguageMap {
    public static let mappings: [String: String] = [
        "pt-BR": "pt"
    ]

    public static let baiduMappings: [String: String] = [
        "zh-CN": "zh",
        "zh-TW": "cht",
        "en": "en",
        "ja": "jp",
        "ko": "kor",
        "fr": "fra",
        "es": "spa",
        "ru": "ru",
        "de": "de",
        "it": "it",
        "vi": "vie",
        "pt": "pt",
        "pt-BR": "pt",
        "nl": "nl",
        "pl": "pl",
        "th": "th",
        "ar": "ar",
        "ms": "may"
    ]

    public static func map(_ code: String) -> String {
        mappings[code] ?? code
    }

    public static func mapForBaidu(_ code: String?) -> String {
        guard let code = code, !code.isEmpty else { return "auto" }
        return baiduMappings[code] ?? code
    }
}
