import Foundation
import Testing
@testable import TranslationKit

@Suite("Baidu Translate Integration Tests", .tags(.network, .slow))
struct BaiduTranslateIntegrationTests {
    private var appid: String {
        ProcessInfo.processInfo.environment["BAIDU_APPID"] ?? ""
    }

    private var key: String {
        ProcessInfo.processInfo.environment["BAIDU_KEY"] ?? ""
    }

    private var isConfigured: Bool {
        !appid.isEmpty && !key.isEmpty
    }

    @Test("English to Chinese translation")
    func testEnglishToChinese() async throws {
        guard isConfigured else {
            Issue.record("BAIDU_APPID and BAIDU_KEY not configured")
            return
        }

        let config = BaiduTranslateConfig(appid: appid, key: key)
        let service = BaiduTranslateService(config: config)

        var task = TranslateTask(
            raw: "Hello, world!",
            sourceLanguage: "en",
            targetLanguage: "zh-CN"
        )

        print("Task: sourceLang=\(task.sourceLanguage ?? "nil"), targetLang=\(task.targetLanguage)")

        try await service.translate(&task)

        #expect(!task.result.isEmpty)
        #expect(task.result != "Hello, world!")
        print("English to Chinese: \(task.result)")
    }

    @Test("Chinese to English translation")
    func testChineseToEnglish() async throws {
        guard isConfigured else {
            Issue.record("BAIDU_APPID and BAIDU_KEY not configured")
            return
        }

        let config = BaiduTranslateConfig(appid: appid, key: key)
        let service = BaiduTranslateService(config: config)

        var task = TranslateTask(
            raw: "你好，世界！",
            sourceLanguage: "zh",
            targetLanguage: "en"
        )
        try await service.translate(&task)

        #expect(!task.result.isEmpty)
        #expect(task.result != "你好，世界！")
        print("Chinese to English: \(task.result)")
    }

    @Test("Auto-detection of source language")
    func testAutoDetectionOfSourceLanguage() async throws {
        guard isConfigured else {
            Issue.record("BAIDU_APPID and BAIDU_KEY not configured")
            return
        }

        let config = BaiduTranslateConfig(appid: appid, key: key)
        let service = BaiduTranslateService(config: config)

        var task = TranslateTask(
            raw: "Hello, world!",
            sourceLanguage: nil,
            targetLanguage: "zh-CN"
        )
        try await service.translate(&task)

        #expect(!task.result.isEmpty)
        #expect(task.result != "Hello, world!")
        print("Auto-detection of source language: \(task.result)")
    }

    @Test("Japanese to Chinese translation")
    func testJapaneseToChinese() async throws {
        guard isConfigured else {
            Issue.record("BAIDU_APPID and BAIDU_KEY not configured")
            return
        }

        let config = BaiduTranslateConfig(appid: appid, key: key)
        let service = BaiduTranslateService(config: config)

        var task = TranslateTask(
            raw: "こんにちは、世界！",
            sourceLanguage: "ja",
            targetLanguage: "zh-CN"
        )
        try await service.translate(&task)

        #expect(!task.result.isEmpty)
        print("Japanese to Chinese: \(task.result)")
    }

    @Test("Using secret string format")
    func testUsingSecretString() async throws {
        guard isConfigured else {
            Issue.record("BAIDU_APPID and BAIDU_KEY not configured")
            return
        }

        let service = BaiduTranslateService()

        var task = TranslateTask(
            raw: "Hello, world!",
            sourceLanguage: "en",
            targetLanguage: "zh-CN",
            secret: "\(appid)#\(key)"
        )
        try await service.translate(&task)

        #expect(!task.result.isEmpty)
        print("Using secret string: \(task.result)")
    }

    @Test("Using secret with action parameter")
    func testUsingSecretWithAction() async throws {
        guard isConfigured else {
            Issue.record("BAIDU_APPID and BAIDU_KEY not configured")
            return
        }

        let config = BaiduTranslateConfig(appid: appid, key: key, action: "1")
        let service = BaiduTranslateService(config: config)

        var task = TranslateTask(
            raw: "Hello, world!",
            sourceLanguage: "en",
            targetLanguage: "zh-CN"
        )
        try await service.translate(&task)

        #expect(!task.result.isEmpty)
        print("Using action=1: \(task.result)")
    }
}
