import Foundation

public final class GoogleAPITranslateService: BaseTranslateService, TranslateService, @unchecked Sendable {
    public static let id = "googleapi"
    public static let name: String? = "Google Translate API"
    public static let type: ServiceType = .sentence
    public static let requiresSecret: Bool = false
    public static let defaultSecret: String? = nil
    public static let secretValidator: (@Sendable (String?) -> SecretValidationResult)? = nil

    public override init(networkClient: NetworkClient = NetworkClient()) {
        super.init(networkClient: networkClient)
    }

    public func translate(_ task: inout TranslateTask) async throws {
        let tk = GoogleSignature.generateTK(for: task.raw)
        let sourceLang = LanguageMap.map(task.sourceLanguage ?? "auto")
        let targetLang = LanguageMap.map(task.targetLanguage)

        let url = try buildTranslateURL(
            baseURL: "https://translate.googleapis.com",
            text: task.raw,
            sourceLang: sourceLang,
            targetLang: targetLang,
            tk: tk
        )

        let (data, response) = try await networkClient.get(url: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranslateError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw TranslateError.requestFailed(statusCode: httpResponse.statusCode)
        }

        let result = try parseResponse(data)
        task.result = result
        task.status = .success
    }
}
