import Foundation

public let openAITranslateService = OpenAITranslateService(baseURL: "https://api.openai.com/v1")

public struct Translate {
    public static let google = GoogleTranslateService()
    public static let googleAPI = GoogleAPITranslateService()
    public static let openAI = openAITranslateService

    public static func baidu(appid: String, key: String, action: String = "0") -> BaiduTranslateService {
        BaiduTranslateService(config: BaiduTranslateConfig(appid: appid, key: key, action: action))
    }

    public init() {}
}

public func translate(
    text: String,
    from sourceLanguage: String? = nil,
    to targetLanguage: String,
    using service: (any TranslateService)? = nil
) async throws -> String {
    let selectedService: any TranslateService = service ?? openAITranslateService
    var task = TranslateTask(
        raw: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage
    )
    try await selectedService.translate(&task)
    return task.result
}
