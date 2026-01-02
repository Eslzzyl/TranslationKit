import Foundation
import Testing
@testable import Translate

@Suite("OpenAI Integration Tests", .tags(.network, .slow))
struct OpenAITranslateIntegrationTests {
    @Test("English to Chinese translation with API key")
    func testEnglishToChineseWithAPIKey() async throws {
        let service = OpenAITranslateService(
            baseURL: "http://10.13.21.221:8080/v1",
            apiKey: "eslzzyl",
            model: "model"
        )

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

    @Test("Auto-detection of source language")
    func testAutoDetectionOfSourceLanguage() async throws {
        let service = OpenAITranslateService(
            baseURL: "http://10.13.21.221:8080/v1",
            apiKey: "eslzzyl",
            model: "model"
        )

        var task = TranslateTask(
            raw: "Hello, world!",
            sourceLanguage: nil,
            targetLanguage: "zh-CN"
        )
        try await service.translate(&task)
        #expect(!task.result.isEmpty)
        print("Auto-detection of source language: \(task.result)")
    }
}
