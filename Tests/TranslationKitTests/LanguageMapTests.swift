import Testing
@testable import TranslationKit

struct LanguageMapTests {
    @Test("Language map returns original code for unmapped values")
    func testUnmappedCode() {
        let result = LanguageMap.map("en")
        #expect(result == "en")
    }

    @Test("Language map converts pt-BR to pt")
    func testPtBRMapping() {
        let result = LanguageMap.map("pt-BR")
        #expect(result == "pt")
    }

    @Test("Language map handles unknown languages")
    func testUnknownLanguage() {
        let result = LanguageMap.map("xx-XX")
        #expect(result == "xx-XX")
    }
}
