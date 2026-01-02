public protocol TranslateService: Sendable {
    var id: String { get }
    var name: String? { get }
    var type: ServiceType { get }
    var requiresSecret: Bool { get }

    func translate(_ task: inout TranslateTask) async throws
}

public enum ServiceType: String, Codable, Sendable {
    case word
    case sentence
}
