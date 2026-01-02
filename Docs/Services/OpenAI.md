# OpenAI 兼容服务

支持 OpenAI 以及所有兼容 OpenAI API 的服务（如 Ollama、Azure 等）。

## 基本用法

```swift
import TranslationKit

let service = OpenAITranslateService(
    baseURL: "https://api.openai.com/v1",
    apiKey: "sk-your-api-key",
    model: "gpt-3.5-turbo"
)

var task = TranslateTask(
    raw: "Hello, world!",
    sourceLanguage: "en",
    targetLanguage: "zh-CN"
)

try await service.translate(&task)
print(task.result)
```

## Ollama

Ollama 本地部署，无需 API 密钥：

```swift
let ollama = OpenAITranslateService(
    baseURL: "http://localhost:11434/v1",
    apiKey: "",  // 无需密钥
    model: "llama3"
)

var task = TranslateTask(
    raw: "Hello",
    targetLanguage: "zh-CN"
)
try await ollama.translate(&task)
```

## 自定义 Prompt

支持自定义系统提示词和用户提示词模板：

```swift
let service = OpenAITranslateService(
    baseURL: "https://api.openai.com/v1",
    apiKey: "sk-your-key",
    model: "gpt-4",
    systemPrompt: "你是一个专业翻译。将{sourceLang}翻译成{targetLang}，只输出译文。",
    userPrompt: "原文：{sourceText}\n译文："
)

var task = TranslateTask(
    raw: "Apple",
    sourceLanguage: "en",
    targetLanguage: "zh-CN"
)
try await service.translate(&task)
```

**Prompt 占位符**：

| 占位符 | 说明 |
|--------|------|
| `{sourceLang}` | 源语言 |
| `{targetLang}` | 目标语言 |
| `{sourceText}` | 原文 |

## 自动检测语言

LLM 可以自动识别源语言，无需指定：

```swift
var task = TranslateTask(
    raw: "Bonjour le monde",  // 法语
    sourceLanguage: nil,      // 让 LLM 自动检测
    targetLanguage: "zh-CN"
)
try await openAIService.translate(&task)
```

## 配置选项

```swift
OpenAITranslateService(
    baseURL: String = "https://api.openai.com/v1",
    apiKey: String = "",           // 可选
    model: String = "gpt-5.1-nano",
    temperature: Double = 0.3,     // 0.0 - 2.0
    systemPrompt: String? = nil,   // 自定义系统提示词
    userPrompt: String? = nil      // 自定义用户提示词模板
)
```

## 错误处理

```swift
do {
    try await service.translate(&task)
} catch TranslateError.unauthorized {
    print("API 密钥无效")
} catch TranslateError.rateLimited {
    print("超出速率限制，请稍后重试")
} catch TranslateError.serverError {
    print("服务器错误")
} catch {
    print("其他错误: \(error.localizedDescription)")
}
```
