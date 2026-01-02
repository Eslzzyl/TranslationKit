# 服务使用指南

本文档介绍 Translate 库中支持的各种翻译服务。

## 支持的服务

| 服务 | ID | 文档 | 需要密钥 |
|------|-----|------|----------|
| Google Translate | `google` | [GoogleTranslate.md](Services/GoogleTranslate.md) | 否 |
| Google Translate API | `googleapi` | [GoogleTranslateAPI.md](Services/GoogleTranslateAPI.md) | 否 |
| OpenAI 兼容服务 | `openai` | [OpenAI.md](Services/OpenAI.md) | 可选 |
| Baidu Translate | `baidu` | [BaiduTranslate.md](Services/BaiduTranslate.md) | 是 |

## 快速开始

### 使用 Google（无需密钥）

```swift
import Translate

let service = GoogleTranslateService()
var task = TranslateTask(
    raw: "Hello, world!",
    sourceLanguage: "en",
    targetLanguage: "zh-CN"
)
try await service.translate(&task)
print(task.result)
```

### 使用 OpenAI

```swift
let service = OpenAITranslateService(
    baseURL: "https://api.openai.com/v1",
    apiKey: "sk-your-key",
    model: "gpt-4"
)
```

### 使用百度

```swift
let baidu = Translate.baidu(appid: "your_appid", key: "your_key")
```

## 语言代码

支持 ISO 639-1 语言代码。参考各服务文档了解特定映射规则。

| 代码 | 语言 |
|------|------|
| `en` | 英语 |
| `zh-CN` | 简体中文 |
| `zh-TW` | 繁体中文 |
| `ja` | 日语 |
| `ko` | 韩语 |
| `fr` | 法语 |
| `de` | 德语 |
| `es` | 西班牙语 |
| `pt` | 葡萄牙语 |
| `ru` | 俄语 |
| `ar` | 阿拉伯语 |

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
