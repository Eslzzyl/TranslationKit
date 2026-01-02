# Google Translate API

使用 Google Translate API 端点，同样无需密钥。

## 基本用法

```swift
let service = GoogleAPITranslateService()
var task = TranslateTask(
    raw: "Hello",
    sourceLanguage: "en",
    targetLanguage: "ja"
)
try await service.translate(&task)
print(task.result)
```

## 与 Google 网页翻译的区别

| 特性 | Google 网页翻译 | Google API |
|------|-----------------|------------|
| 端点 | translate.google.com | translate.googleapis.com |
| 速率限制 | 较宽松 | 较严格 |
| 稳定性 | 可能因反爬变化 | 相对稳定 |
| 签名 | 需要 TK | 需要 TK |

## 注意事项

- 使用官方 API 端点
- 可能有速率限制
- 需要处理 HTTP 429（速率限制）错误
