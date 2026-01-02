# Google Translate

使用 Google 的网页翻译服务，无需 API 密钥。

## 基本用法

```swift
import Translate

func translateWithGoogle() async {
    let service = GoogleTranslateService()
    var task = TranslateTask(
        raw: "Hello, world!",
        sourceLanguage: "en",
        targetLanguage: "zh-CN"
    )

    do {
        try await service.translate(&task)
        print("翻译结果: \(task.result)")
    } catch {
        print("错误: \(error.localizedDescription)")
    }
}
```

## 使用便捷函数

```swift
let result = try await translate(
    text: "The quick brown fox jumps over the lazy dog.",
    from: "en",
    to: "zh-CN"
)
print(result)
```

## 特性

- 无需 API 密钥
- 支持多种语言
- 自动处理 TK 签名（Google 反爬机制）
