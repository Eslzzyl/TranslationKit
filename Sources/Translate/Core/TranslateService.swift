public protocol TranslateService: Sendable {
    static var id: String { get }
    static var name: String? { get }
    static var type: ServiceType { get }
    static var requiresSecret: Bool { get }
    static var defaultSecret: String? { get }
    static var secretValidator: (@Sendable (String?) -> SecretValidationResult)? { get }

    func translate(_ task: inout TranslateTask) async throws
}

public enum ServiceType: String, Codable, Sendable {
    case word
    case sentence
}

public struct SecretValidationResult: Sendable {
    public let secret: String
    public let status: Bool
    public let info: String

    public init(secret: String, status: Bool, info: String) {
        self.secret = secret
        self.status = status
        self.info = info
    }
}
