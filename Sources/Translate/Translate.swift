import Foundation

public let openAITranslateService = OpenAITranslateService()

public struct Translate {
    public static let google = GoogleTranslateService()
    public static let googleAPI = GoogleAPITranslateService()
    public static let openAI = openAITranslateService

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
