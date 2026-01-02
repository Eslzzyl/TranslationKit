# API 参考

## TranslateTask

翻译任务模型。

```swift
public struct TranslateTask: @unchecked Sendable {
    public var raw: String              // 原文
    public var result: String           // 译文
    public var sourceLanguage: String?  // 源语言
    public var targetLanguage: String   // 目标语言
    public var secret: String?          // API 密钥
    public var status: TaskStatus       // 状态
}
```

### 初始化

```swift
// 指定源语言
TranslateTask(
    raw: "Hello",
    sourceLanguage: "en",
    targetLanguage: "zh-CN"
)

// 自动检测源语言
TranslateTask(
    raw: "Hello",
    sourceLanguage: nil,
    targetLanguage: "zh-CN"
)
```

### TaskStatus

```swift
public enum TaskStatus: String, @unchecked Sendable {
    case pending      // 等待处理
    case processing   // 处理中
    case success      // 成功
    case failed       // 失败
}
```

---

## TranslateService

翻译服务协议。

```swift
public protocol TranslateService: Sendable {
    var id: String { get }              // 服务 ID
    var name: String? { get }           // 服务名称
    var type: ServiceType { get }       // 服务类型
    var requiresSecret: Bool { get }    // 是否需要密钥

    func translate(_ task: inout TranslateTask) async throws
}
```

### ServiceType

```swift
public enum ServiceType: String, Codable, Sendable {
    case word       // 单词翻译
    case sentence   // 句子翻译
}
```

---

## TranslateError

```swift
public enum TranslateError: Error, LocalizedError, Sendable {
    case invalidURL
    case requestFailed(statusCode: Int)
    case invalidResponse
    case parsingError
    case signatureError
    case networkError(underlying: any Error)
    case languageNotSupported(String)
    case unauthorized
    case rateLimited
    case serverError
    case apiError(String)
}
```

---

## GoogleTranslateService

Google 网页翻译服务。

```swift
public final class GoogleTranslateService: BaseTranslateService, TranslateService {
    public var id: String { "google" }
    public var name: String? { "Google" }
    public var type: ServiceType { .sentence }
    public var requiresSecret: Bool { false }

    public init()
}
```

---

## GoogleAPITranslateService

Google Translate API 服务。

```swift
public final class GoogleAPITranslateService: BaseTranslateService, TranslateService {
    public var id: String { "googleapi" }
    public var name: String? { "Google API" }
    public var type: ServiceType { .sentence }
    public var requiresSecret: Bool { false }

    public init()
}
```

---

## OpenAITranslateService

OpenAI 兼容的 LLM 翻译服务。

```swift
public final class OpenAITranslateService: BaseTranslateService, TranslateService {
    public var id: String { "openai" }
    public var name: String? { "OpenAI" }
    public var type: ServiceType { .sentence }
    public var requiresSecret: Bool { false }

    public init(
        baseURL: String = "https://api.openai.com/v1",
        apiKey: String = "",
        model: String = "gpt-5.1-nano",
        temperature: Double = 0.3,
        systemPrompt: String? = nil,
        userPrompt: String? = nil
    )
}
```

### 参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `baseURL` | `String` | `https://api.openai.com/v1` | API 基础地址 |
| `apiKey` | `String` | `""` | API 密钥（可选） |
| `model` | `String` | `gpt-5.1-nano` | 模型名称 |
| `temperature` | `Double` | `0.3` | 采样温度 (0.0-2.0) |
| `systemPrompt` | `String?` | `nil` | 自定义系统提示词 |
| `userPrompt` | `String?` | `nil` | 自定义用户提示词模板 |

---

## 便捷函数

```swift
public func translate(
    text: String,
    from sourceLanguage: String? = nil,
    to targetLanguage: String,
    using service: (any TranslateService)? = nil
) async throws -> String
```

### 示例

```swift
// 使用默认服务（OpenAI）
let result = try await translate(
    text: "Hello",
    from: "en",
    to: "zh-CN"
)

// 使用 Google
let result = try await translate(
    text: "Hello",
    from: "en",
    to: "zh-CN",
    using: Translate.google
)

// 使用自定义 OpenAI 配置
let customService = OpenAITranslateService(
    baseURL: "https://api.example.com/v1",
    apiKey: "your-key",
    model: "gpt-4"
)
let result = try await translate(
    text: "Hello",
    to: "zh-CN",
    using: customService
)
```

---

## 静态访问

```swift
public struct Translate {
    public static let google = GoogleTranslateService()
    public static let googleAPI = GoogleAPITranslateService()
    public static let openAI = OpenAITranslateService()
}
```

### 示例

```swift
Translate.google
Translate.googleAPI
Translate.openAI
```
