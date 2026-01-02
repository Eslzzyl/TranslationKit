import Testing
@testable import Translate

@Suite("OpenAI Translate Service Tests")
struct OpenAITranslateServiceTests {
    @Test("Service has correct properties")
    func testServiceProperties() {
        #expect(OpenAITranslateService.id == "openai")
        #expect(OpenAITranslateService.name == "OpenAI")
        #expect(OpenAITranslateService.type == .sentence)
        #expect(OpenAITranslateService.requiresSecret == false)
    }

    @Test("Service does not require secret by default")
    func testRequiresSecretIsFalse() {
        #expect(OpenAITranslateService.requiresSecret == false)
    }

    @Test("Task status transitions correctly")
    func testTaskStatusTransitions() {
        let task = TranslateTask(
            raw: "Hello",
            targetLanguage: "zh-CN"
        )
        #expect(task.status == .pending)
        #expect(task.result.isEmpty)
    }

    @Test("Task with source language")
    func testTaskWithSourceLanguage() {
        let task = TranslateTask(
            raw: "Hello",
            sourceLanguage: "en",
            targetLanguage: "zh-CN"
        )
        #expect(task.sourceLanguage == "en")
        #expect(task.targetLanguage == "zh-CN")
    }

    @Test("Task without source language for auto-detection")
    func testTaskWithoutSourceLanguage() {
        let task = TranslateTask(
            raw: "Hello",
            sourceLanguage: nil,
            targetLanguage: "zh-CN"
        )
        #expect(task.sourceLanguage == nil)
        #expect(task.targetLanguage == "zh-CN")
    }
}
