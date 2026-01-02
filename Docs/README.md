# TranslationKit

一个基于现代 Swift 的翻译库，支持多种翻译服务。

## 特性

- **平台无关**：仅使用 Foundation，无 Darwin 特定 API
- **线程安全**：使用 `Sendable` 协议
- **异步支持**：完全基于 `async/await`
- **测试覆盖**：使用 Swift Testing 框架

## 支持的服务

| 服务 | ID | 需要密钥 |
|------|-----|----------|
| Google Translate | `google` | 否 |
| Google Translate API | `googleapi` | 否 |
| OpenAI (兼容接口) | `openai` | 可选 |

## 快速开始

```swift
import TranslationKit

// 使用 Google 翻译
let googleService = Translate.google

// 使用 OpenAI 翻译
let openAIService = Translate.openAI

// 便捷函数
let result = try await translate(
    text: "Hello, world!",
    from: "en",
    to: "zh-CN"
)
```

## 安装

### Swift Package Manager

```swift
.package(url: "https://github.com/your-repo/TranslationKit.git", from: "1.0.0")
```

## 文档

- [服务使用指南](Services.md)
- [API 参考](API.md)

## 测试

```bash
# 运行所有测试
swift test

# 运行特定模块测试
swift test --filter OpenAITranslateServiceTests
swift test --filter GoogleTranslateIntegrationTests
```
