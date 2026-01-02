import Foundation

public struct NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    public func get(url: URL) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30

        do {
            return try await session.data(for: request)
        } catch {
            throw TranslateError.networkError(underlying: error)
        }
    }

    public func post(url: URL, body: Data?, headers: [String: String] = [:]) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.httpBody = body

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            return try await session.data(for: request)
        } catch {
            throw TranslateError.networkError(underlying: error)
        }
    }
}
