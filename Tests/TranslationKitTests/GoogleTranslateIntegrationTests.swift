import Testing
@testable import TranslationKit

extension Tag {
    @Tag static var network: Self
    @Tag static var slow: Self
}

@Suite("Google Translate Integration Tests", .tags(.network, .slow))
struct GoogleTranslateIntegrationTests {
    @Test("English to Chinese translation")
    func testEnglishToChinese() async throws {
        let service = GoogleTranslateService()
        var task = TranslateTask(
            raw: "Hello, world!",
            sourceLanguage: "en",
            targetLanguage: "zh-CN"
        )
        try await service.translate(&task)
        #expect(!task.result.isEmpty)
        #expect(task.result != "Hello, world!")
        print("English to Chinese: \(task.result)")
    }
}
