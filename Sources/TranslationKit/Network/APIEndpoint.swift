import Foundation

public enum APIEndpoint {
    case googleWeb
    case googleAPI

    public var baseURL: String {
        switch self {
        case .googleWeb:
            return "https://translate.google.com"
        case .googleAPI:
            return "https://translate.googleapis.com"
        }
    }

    public var translatePath: String {
        return "/translate_a/single"
    }

    public var url: URL? {
        URL(string: baseURL + translatePath)
    }
}
