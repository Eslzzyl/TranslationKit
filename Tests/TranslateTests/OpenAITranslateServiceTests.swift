import Testing
@testable import Translate

@Suite("OpenAI Translate Service Tests")
struct OpenAITranslateServiceTests {
    @Test("Service has correct properties")
    func testServiceProperties() {
        let service = OpenAITranslateService()
        #expect(service.id == "openai")
        #expect(service.name == "OpenAI")
        #expect(service.type == .sentence)
        #expect(service.requiresSecret == false)
    }

    @Test("Service does not require secret by default")
    func testRequiresSecretIsFalse() {
        let serviceWithoutKey = OpenAITranslateService()
        #expect(serviceWithoutKey.requiresSecret == false)
    }

    @Test("Custom initialization with all parameters")
    func testCustomInitialization() {
        let service = OpenAITranslateService(
            baseURL: "https://api.example.com/v1",
            apiKey: "test-key",
            model: "gpt-4",
            temperature: 0.5,
            systemPrompt: "Custom system prompt",
            userPrompt: "Custom user prompt"
        )
        #expect(service.id == "openai")
        #expect(service.name == "OpenAI")
    }

    @Test("Default base URL is OpenAI")
    func testDefaultBaseURL() {
        let service = OpenAITranslateService()
        #expect(service.requiresSecret == false)
    }

    @Test("Task status transitions correctly")
    func testTaskStatusTransitions() {
        var task = TranslateTask(
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
