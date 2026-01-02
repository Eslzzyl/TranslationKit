import Testing
@testable import Translate

struct GoogleTranslateServiceTests {
    @Test("Service has correct properties")
    func testServiceProperties() {
        let service = GoogleTranslateService()
        #expect(service.id == "google")
        #expect(service.type == .sentence)
        #expect(service.requiresSecret == false)
    }

    @Test("API service has correct properties")
    func testAPIServiceProperties() {
        let service = GoogleAPITranslateService()
        #expect(service.id == "googleapi")
        #expect(service.type == .sentence)
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
}
