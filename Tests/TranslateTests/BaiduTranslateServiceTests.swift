import Foundation
import Testing
@testable import Translate

@Suite("Baidu Translate Service Tests")
struct BaiduTranslateServiceTests {
    @Test("Service properties")
    func testServiceProperties() {
        #expect(BaiduTranslateService.id == "baidu")
        #expect(BaiduTranslateService.name == "Baidu Translate")
        #expect(BaiduTranslateService.type == .sentence)
        #expect(BaiduTranslateService.requiresSecret == true)
        #expect(BaiduTranslateService.defaultSecret == "appid#key")
    }

    @Test("Valid secret format with 2 parts")
    func testValidSecretWithTwoParts() {
        let validator = BaiduTranslateService.secretValidator!
        let result = validator("123456#abcdefg")
        #expect(result.secret == "123456#abcdefg")
        #expect(result.status == true)
        #expect(result.info.contains("AppID: 123456"))
        #expect(result.info.contains("Key: abcdefg"))
        #expect(result.info.contains("Action: 0"))
    }

    @Test("Valid secret format with 3 parts")
    func testValidSecretWithThreeParts() {
        let validator = BaiduTranslateService.secretValidator!
        let result = validator("123456#abcdefg#1")
        #expect(result.secret == "123456#abcdefg#1")
        #expect(result.status == true)
        #expect(result.info.contains("AppID: 123456"))
        #expect(result.info.contains("Key: abcdefg"))
        #expect(result.info.contains("Action: 1"))
    }

    @Test("Invalid secret format with 1 part")
    func testInvalidSecretWithOnePart() {
        let validator = BaiduTranslateService.secretValidator!
        let result = validator("onlyappid")
        #expect(result.status == false)
        #expect(result.info.contains("密钥格式错误"))
    }

    @Test("Empty secret")
    func testEmptySecret() {
        let validator = BaiduTranslateService.secretValidator!
        let result = validator("")
        #expect(result.status == false)
        #expect(result.info.contains("未设置密钥"))
    }

    @Test("Nil secret")
    func testNilSecret() {
        let validator = BaiduTranslateService.secretValidator!
        let result = validator(nil)
        #expect(result.status == false)
        #expect(result.info.contains("未设置密钥"))
    }

    @Test("Default secret placeholder")
    func testDefaultSecretPlaceholder() {
        let validator = BaiduTranslateService.secretValidator!
        let result = validator("appid#key")
        #expect(result.status == true)
        #expect(result.info.contains("AppID: appid"))
    }
}

@Suite("Baidu Translate Config Tests")
struct BaiduTranslateConfigTests {
    @Test("Config with all parameters")
    func testConfigWithAllParameters() {
        let config = BaiduTranslateConfig(appid: "123456", key: "abcdefg", action: "1")
        #expect(config.appid == "123456")
        #expect(config.key == "abcdefg")
        #expect(config.action == "1")
    }

    @Test("Config with default action")
    func testConfigWithDefaultAction() {
        let config = BaiduTranslateConfig(appid: "123456", key: "abcdefg")
        #expect(config.appid == "123456")
        #expect(config.key == "abcdefg")
        #expect(config.action == "0")
    }

    @Test("Parse valid secret with 2 parts")
    func testParseValidSecretWithTwoParts() {
        let config = BaiduTranslateConfig.parse(from: "123456#abcdefg")
        #expect(config != nil)
        #expect(config?.appid == "123456")
        #expect(config?.key == "abcdefg")
        #expect(config?.action == "0")
    }

    @Test("Parse valid secret with 3 parts")
    func testParseValidSecretWithThreeParts() {
        let config = BaiduTranslateConfig.parse(from: "123456#abcdefg#1")
        #expect(config != nil)
        #expect(config?.appid == "123456")
        #expect(config?.key == "abcdefg")
        #expect(config?.action == "1")
    }

    @Test("Parse invalid secret with 1 part")
    func testParseInvalidSecretWithOnePart() {
        let config = BaiduTranslateConfig.parse(from: "onlyappid")
        #expect(config == nil)
    }

    @Test("Parse empty secret")
    func testParseEmptySecret() {
        let config = BaiduTranslateConfig.parse(from: "")
        #expect(config == nil)
    }

    @Test("Parse empty appid")
    func testParseEmptyAppid() {
        let config = BaiduTranslateConfig.parse(from: "#abcdefg")
        #expect(config == nil)
    }

    @Test("Parse empty key")
    func testParseEmptyKey() {
        let config = BaiduTranslateConfig.parse(from: "123456#")
        #expect(config == nil)
    }
}

@Suite("Baidu Language Mapping Tests")
struct BaiduLanguageMappingTests {
    @Test("Chinese Simplified to Baidu code")
    func testChineseSimplifiedMapping() {
        #expect(LanguageMap.mapForBaidu("zh-CN") == "zh")
    }

    @Test("Chinese Traditional to Baidu code")
    func testChineseTraditionalMapping() {
        #expect(LanguageMap.mapForBaidu("zh-TW") == "cht")
    }

    @Test("Japanese to Baidu code")
    func testJapaneseMapping() {
        #expect(LanguageMap.mapForBaidu("ja") == "jp")
    }

    @Test("Korean to Baidu code")
    func testKoreanMapping() {
        #expect(LanguageMap.mapForBaidu("ko") == "kor")
    }

    @Test("French to Baidu code")
    func testFrenchMapping() {
        #expect(LanguageMap.mapForBaidu("fr") == "fra")
    }

    @Test("Spanish to Baidu code")
    func testSpanishMapping() {
        #expect(LanguageMap.mapForBaidu("es") == "spa")
    }

    @Test("Unsupported language returns itself")
    func testUnsupportedLanguage() {
        #expect(LanguageMap.mapForBaidu("xx") == "xx")
    }

    @Test("English to Baidu code")
    func testEnglishMapping() {
        #expect(LanguageMap.mapForBaidu("en") == "en")
    }

    @Test("Nil language returns auto")
    func testNilLanguageReturnsAuto() {
        #expect(LanguageMap.mapForBaidu(nil) == "auto")
    }

    @Test("Empty language returns auto")
    func testEmptyLanguageReturnsAuto() {
        #expect(LanguageMap.mapForBaidu("") == "auto")
    }
}
