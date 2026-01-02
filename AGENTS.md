# 基于现代 Swift 的翻译库

你需要根据用户的需求，将 zotero-pdf-translate 这个项目部分地翻译成 Swift。

这是一个翻译库，能够集成多种翻译服务（通过逆向网页服务或浏览器扩展，或者官方 API），并为其他 Swift 项目提供可调用的翻译 API。

zotero-pdf-translate 是一个基于 TypeScipt 的 Zotero 软件插件，其中集成了多种翻译服务，并且已经对常用的翻译服务进行了逆向，可以参考。

# 要求

使用最新的 Swift 特性和语法。此项目使用 Swift Testing 作为测试框架。在实现某个特定的翻译服务时，仅测试这个服务，不要测试其他服务。

仔细参考 zotero-pdf-translate 项目中的实现。

总是以中文回复用户。

# 项目架构

## 目录结构

```
Translate/
├── Package.swift                    # Swift 包配置
├── README.md                        # 项目说明
├── Docs/                            # 文档目录
│   ├── README.md                    # 快速开始
│   ├── Services.md                  # 服务使用指南（索引）
│   ├── Services/
│   │   ├── GoogleTranslate.md       # Google 网页翻译
│   │   ├── GoogleTranslateAPI.md    # Google API 端点
│   │   ├── OpenAI.md                # OpenAI 兼容服务
│   │   └── BaiduTranslate.md        # 百度翻译
│   └── API.md                       # API 参考
├── Sources/Translate/
│   ├── Core/
│   │   ├── Errors.swift             # 错误类型定义
│   │   ├── LanguageMap.swift        # 语言代码映射
│   │   ├── TranslateService.swift   # 服务协议
│   │   └── TranslateTask.swift      # 翻译任务模型
│   ├── Crypto/
│   │   ├── GoogleSignature.swift    # TK 签名算法
│   │   └── RLSigner.swift           # RL 哈希函数
│   ├── Network/
│   │   ├── APIEndpoint.swift        # API 端点
│   │   └── NetworkClient.swift      # 网络请求封装
│   ├── Services/
│   │   ├── BaseTranslateService.swift     # 基础服务类
│   │   ├── BaiduTranslateService.swift    # 百度翻译
│   │   ├── GoogleAPIService.swift         # Google API 变体
│   │   ├── GoogleTranslateService.swift   # Google 网页翻译
│   │   └── OpenAITranslateService.swift   # OpenAI 兼容 LLM 翻译
│   └── Translate.swift
└── Tests/TranslateTests/
    ├── GoogleSignatureTests.swift              # 签名算法测试
    ├── GoogleTranslateServiceTests.swift       # Google 服务测试
    ├── GoogleTranslateIntegrationTests.swift   # Google 集成测试
    ├── OpenAITranslateServiceTests.swift       # OpenAI 服务单元测试
    ├── OpenAITranslateIntegrationTests.swift   # OpenAI 集成测试
    ├── BaiduTranslateServiceTests.swift        # 百度翻译测试
    ├── BaiduTranslateIntegrationTests.swift    # 百度翻译集成测试
    └── LanguageMapTests.swift                  # 语言映射测试
```

## 核心组件

### 1. TranslateService 协议

```swift
public protocol TranslateService: Sendable {
    var id: String { get }
    var name: String? { get }
    var type: ServiceType { get }
    var requiresSecret: Bool { get }

    func translate(_ task: inout TranslateTask) async throws
}
```

### 2. TranslateTask 模型

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

### 3. Google 签名算法

TK 签名算法是 Google 翻译的核心反爬机制，位于 `GoogleSignature.swift`：

```swift
struct GoogleSignature {
    private static let b: Int64 = 406644
    private static let b1: Int64 = 3293161072
    private static let salt1 = "+-a^+6"
    private static let salt2 = "+-3^+b+-f"

    static func generateTK(for text: String) -> String
}
```

### 4. 服务实现

- `GoogleTranslateService`：使用 `translate.google.com` 网页端
- `GoogleAPITranslateService`：使用 `translate.googleapis.com` API 端点

## 实现的服务

| 服务 | ID | 类型 | 需要密钥 |
|------|-----|------|----------|
| Google Translate | `google` | sentence | 否 |
| Google Translate API | `googleapi` | sentence | 否 |
| OpenAI (兼容接口) | `openai` | sentence | 可选 |
| Baidu Translate | `baidu` | sentence | 是 |

## 百度翻译服务

`BaiduTranslateService` 使用百度翻译开放平台 API：

```swift
let baidu = BaiduTranslateService()
var task = TranslateTask(
    raw: "Hello, world!",
    sourceLanguage: "en",
    targetLanguage: "zh-CN",
    secret: "your_appid#your_key"
)
```

配置项：

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `secret` | API 密钥，格式 `AppID#Key#Action(optional)` | `appid#key` |

密钥格式说明：
- `AppID`：百度翻译开放平台应用 ID
- `Key`：百度翻译开放平台应用密钥
- `Action`：(可选) 翻译类型，`0` 表示普通翻译，`1` 表示专业翻译

百度语言代码映射：

| 原始代码 | 百度代码 |
|----------|----------|
| `zh-CN` | `zh` |
| `zh-TW` | `cht` |
| `ja` | `jp` |
| `ko` | `kor` |
| `fr` | `fra` |
| `es` | `spa` |

## OpenAI 兼容服务

`OpenAITranslateService` 支持所有 OpenAI 兼容的 API：

```swift
// 标准 OpenAI
let openAI = OpenAITranslateService(
    baseURL: "https://api.openai.com/v1",
    apiKey: "sk-...",
    model: "gpt-4"
)

// Ollama
let ollama = OpenAITranslateService(
    baseURL: "http://localhost:11434/v1",
    model: "llama3"
)
```

配置项：

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `baseURL` | API 基础地址 | `https://api.openai.com/v1` |
| `apiKey` | API 密钥 | 空字符串（可选） |
| `model` | 模型名称 | `gpt-5.1-nano` |
| `temperature` | 采样温度 | `0.3` |
| `systemPrompt` | 系统提示词 | 默认英文 prompt |
| `userPrompt` | 用户提示词模板 | 默认模板 |

支持不指定源语言（LLM 自动检测）。

# 测试框架

使用 **Swift Testing** 作为测试框架。

## 运行测试

```bash
# 运行所有测试
swift test

# 运行特定模块测试
swift test --filter OpenAITranslateServiceTests  # OpenAI 单元测试
swift test --filter OpenAITranslateIntegrationTests  # OpenAI 集成测试
swift test --filter GoogleTranslateIntegrationTests  # Google 集成测试
swift test --filter GoogleSignatureTests  # Google 签名测试
swift test --filter GoogleTranslateServiceTests  # Google 服务测试
swift test --filter LanguageMapTests  # 语言映射测试
swift test --filter BaiduTranslateServiceTests  # 百度翻译测试

# 按标签运行测试
swift test --list-tests  # 列出所有可用测试

# 在 Xcode 中
open Package.swift
# 按 Cmd+U 运行测试
```

## 测试文件

| 文件 | 测试内容 |
|------|----------|
| `GoogleSignatureTests.swift` | TK 签名算法测试（确定性、编码、多语言） |
| `GoogleTranslateServiceTests.swift` | 服务属性测试、任务状态测试 |
| `GoogleTranslateIntegrationTests.swift` | Google 实际翻译测试（需要网络） |
| `OpenAITranslateServiceTests.swift` | OpenAI 服务属性、初始化测试 |
| `OpenAITranslateIntegrationTests.swift` | OpenAI 实际翻译测试（需要 API Key） |
| `LanguageMapTests.swift` | 语言代码映射测试 |
| `BaiduTranslateServiceTests.swift` | 百度翻译服务属性、密钥验证、语言映射测试 |

## 集成测试示例

```swift
@Suite("Google Translate Integration Tests", .tags(.network, .slow))
struct GoogleTranslateIntegrationTests {
    @Test("English to Chinese translation")
    func testEnglishToChinese() async throws {
        let service = GoogleTranslateService()
        var task = TranslateTask(
            raw: "Hello, world!",
            sourceLanguage: "en",
            targetLanguage: "zh-CN"
        )
        try await service.translate(&task)
        #expect(!task.result.isEmpty)
    }
}
```

# 使用方法

```swift
import Translate

func translateExample() async {
    let service = GoogleTranslateService()
    var task = TranslateTask(
        raw: "Hello, world!",
        sourceLanguage: "en",
        targetLanguage: "zh-CN"
    )

    do {
        try await service.translate(&task)
        print("Translation: \(task.result)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

# 技术要点

1. **平台无关性**：仅使用 Foundation，无 Darwin 特定 API
2. **线程安全**：使用 `Sendable` 协议和 `@unchecked Sendable`
3. **异步支持**：完全基于 `async/await`
4. **错误处理**：遵循 Swift idiomatic 错误处理模式
5. **测试优先**：所有核心功能都有对应测试

# 已知问题

- Google 翻译有速率限制（HTTP 429），集成测试可能触发限流
- 签名算法对极短文本可能产生碰撞（这是预期行为）
