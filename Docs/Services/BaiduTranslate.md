# Baidu Translate

使用百度翻译开放平台 API，需要申请 APPID 和密钥。

## 申请流程

1. 访问 [百度翻译开放平台](http://api.fanyi.baidu.com/)
2. 注册开发者账号
3. 创建翻译应用，获取 APPID 和密钥
4. 开通通用翻译 API 服务

## 基本用法

### 方式一：使用配置对象

```swift
import TranslationKit

let config = BaiduTranslateConfig(appid: "your_appid", key: "your_key")
let baidu = BaiduTranslateService(config: config)

var task = TranslateTask(
    raw: "Hello, world!",
    sourceLanguage: "en",
    targetLanguage: "zh-CN"
)

try await baidu.translate(&task)
print(task.result)
```

### 方式二：使用便捷方法

```swift
let baidu = Translate.baidu(appid: "your_appid", key: "your_key")
```

### 方式三：使用密钥字符串

```swift
var task = TranslateTask(
    raw: "Hello",
    sourceLanguage: "en",
    targetLanguage: "zh-CN",
    secret: "your_appid#your_key"  // 格式: AppID#Key#Action
)

let baidu = BaiduTranslateService()
try await baidu.translate(&task)
```

## 自动检测源语言

百度翻译 API 支持自动检测源语言，只需将 `sourceLanguage` 设为 `nil` 或不指定：

```swift
var task = TranslateTask(
    raw: "Hello, world!",  // 任意语言
    sourceLanguage: nil,    // 自动检测
    targetLanguage: "zh-CN",
    secret: "appid#key"
)

try await baidu.translate(&task)
// 百度会自动识别源语言
```

## 翻译类型 (Action)

第三个参数 `action` 控制翻译类型：

| 值 | 说明 |
|----|------|
| `0` | 普通翻译（默认） |
| `1` | 专业翻译（需要开通专业翻译服务） |

```swift
let config = BaiduTranslateConfig(appid: "appid", key: "key", action: "1")
let baidu = BaiduTranslateService(config: config)
```

## 语言代码映射

百度翻译使用自己的语言代码：

| 原始代码 | 百度代码 |
|----------|----------|
| `zh-CN` | `zh` |
| `zh-TW` | `cht` |
| `en` | `en` |
| `ja` | `jp` |
| `ko` | `kor` |
| `fr` | `fra` |
| `es` | `spa` |
| `ru` | `ru` |
| `de` | `de` |
| `vi` | `vie` |

库会自动进行映射，无需手动转换。

## 完整示例

```swift
import TranslationKit

func translateWithBaidu() async {
    // 创建配置
    let config = BaiduTranslateConfig(
        appid: "your_appid",
        key: "your_key",
        action: "0"
    )
    
    // 创建服务
    let baidu = BaiduTranslateService(config: config)
    
    // 创建任务
    var task = TranslateTask(
        raw: "The quick brown fox jumps over the lazy dog.",
        sourceLanguage: "en",
        targetLanguage: "zh-CN"
    )
    
    do {
        try await baidu.translate(&task)
        print("翻译结果: \(task.result)")
    } catch {
        print("错误: \(error.localizedDescription)")
    }
}
```

## 错误处理

```swift
do {
    try await baidu.translate(&task)
} catch TranslateError.missingSecret {
    print("未提供 API 密钥")
} catch TranslateError.invalidSecretFormat(let message) {
    print("密钥格式错误: \(message)")
} catch TranslateError.apiError(let message) {
    print("API 错误: \(message)")
} catch {
    print("其他错误: \(error.localizedDescription)")
}
```

## 注意事项

1. **签名生成**：百度使用 MD5 签名算法，需要按 `appid + q + salt + key` 的顺序拼接
2. **随机数**：每次请求需要不同的 salt（时间戳）
3. **编码**：query 不需要 URL encode（签名生成时），但发送请求时需要
4. **速率限制**：百度翻译 API 有 QPS 限制，请参考官方文档
