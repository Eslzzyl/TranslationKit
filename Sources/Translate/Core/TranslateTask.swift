public struct TranslateTask: @unchecked Sendable {
    public var raw: String
    public var result: String
    public var sourceLanguage: String?
    public var targetLanguage: String
    public var secret: String?
    public var status: TaskStatus

    public init(
        raw: String,
        sourceLanguage: String? = nil,
        targetLanguage: String,
        secret: String? = nil
    ) {
        self.raw = raw
        self.result = ""
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.secret = secret
        self.status = .pending
    }

    public mutating func reset() {
        self.result = ""
        self.status = .pending
    }
}

public enum TaskStatus: String, @unchecked Sendable {
    case pending
    case processing
    case success
    case failed
}
