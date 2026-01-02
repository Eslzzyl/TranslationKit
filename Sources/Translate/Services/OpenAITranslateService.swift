import Foundation

public struct LLMMessage: Codable, Sendable {
    public let role: String
    public let content: String

    public init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}

public struct LLMChatRequest: Codable, Sendable {
    public let model: String
    public let messages: [LLMMessage]
    public let temperature: Double
    public let stream: Bool

    public init(model: String, messages: [LLMMessage], temperature: Double, stream: Bool = false) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.stream = stream
    }
}

public struct LLMChoice: Codable, Sendable {
    public let message: LLMMessage
    public let finish_reason: String?
}

public struct LLMChatResponse: Codable, Sendable {
    public let choices: [LLMChoice]
}

public final class OpenAITranslateService: BaseTranslateService, TranslateService, @unchecked Sendable {
    private let baseURL: String
    private let apiKey: String
    private let model: String
    private let temperature: Double
    private let systemPrompt: String
    private let userPrompt: String

    private static let defaultSystemPrompt = """
    You are a professional translator. Translate the following text into {targetLang}. \
    Only output the translated text, nothing else.
    """

    private static let defaultSystemPromptWithSource = """
    You are a professional translator. Translate the following text from {sourceLang} into {targetLang}. \
    Only output the translated text, nothing else.
    """

    private static let defaultUserPrompt = "{sourceText}"

    public init(
        baseURL: String = "https://api.openai.com/v1",
        apiKey: String = "",
        model: String = "gpt-5.1-nano",
        temperature: Double = 0.3,
        systemPrompt: String? = nil,
        userPrompt: String? = nil
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.model = model
        self.temperature = temperature
        self.systemPrompt = systemPrompt ?? Self.defaultSystemPrompt
        self.userPrompt = userPrompt ?? Self.defaultUserPrompt
    }

    public static let id: String = "openai"
    public static let name: String? = "OpenAI"
    public static let type: ServiceType = .sentence
    public static let requiresSecret: Bool = false
    public static let defaultSecret: String? = nil
    public static let secretValidator: (@Sendable (String?) -> SecretValidationResult)? = nil

    public func translate(_ task: inout TranslateTask) async throws {
        task.status = .processing

        let messages = buildMessages(for: task)

        let url = try buildURL()
        let body = LLMChatRequest(
            model: model,
            messages: messages,
            temperature: temperature,
            stream: false
        )
        let headers = buildHeaders()
        let bodyData = try JSONEncoder().encode(body)

        let (data, response) = try await networkClient.post(url: url, body: bodyData, headers: headers)
        try validateResponse(response: response, data: data)
        task.result = try parseResponse(data: data)
        task.status = .success
    }

    private func buildMessages(for task: TranslateTask) -> [LLMMessage] {
        let sourceLang = task.sourceLanguage ?? "auto"
        let targetLang = task.targetLanguage
        let sourceText = task.raw

        let resolvedUserPrompt = self.userPrompt
            .replacingOccurrences(of: "{sourceLang}", with: sourceLang)
            .replacingOccurrences(of: "{targetLang}", with: targetLang)
            .replacingOccurrences(of: "{sourceText}", with: sourceText)

        let resolvedSystemPromptFinal = self.systemPrompt
            .replacingOccurrences(of: "{sourceLang}", with: sourceLang)
            .replacingOccurrences(of: "{targetLang}", with: targetLang)
            .replacingOccurrences(of: "{sourceText}", with: sourceText)

        return [
            LLMMessage(role: "system", content: resolvedSystemPromptFinal),
            LLMMessage(role: "user", content: resolvedUserPrompt)
        ]
    }

    private func buildURL() throws -> URL {
        guard let url = URL(string: baseURL)?.appendingPathComponent("chat/completions") else {
            throw TranslateError.invalidURL
        }
        return url
    }

    private func buildHeaders() -> [String: String] {
        var headers = ["Content-Type": "application/json"]
        if !apiKey.isEmpty {
            headers["Authorization"] = "Bearer \(apiKey)"
        }
        return headers
    }

    private func validateResponse(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranslateError.networkError(underlying: NSError(domain: "Network", code: -1))
        }

        switch httpResponse.statusCode {
        case 200:
            return
        case 401:
            throw TranslateError.unauthorized
        case 429:
            throw TranslateError.rateLimited
        case 500...599:
            throw TranslateError.serverError
        default:
            if let errorResponse = try? JSONDecoder().decode(LLMErrorResponse.self, from: data),
               let message = errorResponse.error?.message {
                throw TranslateError.apiError(message)
            }
            throw TranslateError.networkError(underlying: NSError(domain: "Network", code: httpResponse.statusCode))
        }
    }

    private func parseResponse(data: Data) throws -> String {
        let response = try JSONDecoder().decode(LLMChatResponse.self, from: data)

        guard let firstChoice = response.choices.first else {
            throw TranslateError.parsingError
        }

        let content = firstChoice.message.content
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct LLMErrorResponse: Codable {
    let error: LLMError?
}

private struct LLMError: Codable {
    let message: String
    let type: String?
}
