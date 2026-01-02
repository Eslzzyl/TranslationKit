import Testing
@testable import Translate

struct GoogleSignatureTests {
    @Test("TL signature generates correct format")
    func testSignatureFormat() {
        let tk = GoogleSignature.generateTK(for: "hello")
        #expect(tk.contains("."))
        let parts = tk.split(separator: ".", omittingEmptySubsequences: false)
        #expect(parts.count == 2)
    }

    @Test("Empty string produces valid signature")
    func testEmptyString() {
        let tk = GoogleSignature.generateTK(for: "")
        #expect(!tk.isEmpty)
    }

    @Test("Chinese characters encoding")
    func testChineseCharacters() {
        let tk = GoogleSignature.generateTK(for: "你好")
        #expect(tk.contains("."))
    }

    @Test("Japanese characters encoding")
    func testJapaneseCharacters() {
        let tk = GoogleSignature.generateTK(for: "こんにちは")
        #expect(tk.contains("."))
    }

    @Test("Emoji handling")
    func testEmoji() {
        let inputs = ["hello world", "café", "🎉", "Привет", "مرحبا"]
        for input in inputs {
            let tk = GoogleSignature.generateTK(for: input)
            #expect(!tk.isEmpty, "Failed for input: \(input)")
        }
    }

    @Test("Signature is deterministic")
    func testDeterministic() {
        let text = "Hello, World!"
        let tk1 = GoogleSignature.generateTK(for: text)
        let tk2 = GoogleSignature.generateTK(for: text)
        #expect(tk1 == tk2)
    }

    @Test("Signature for same text is consistent")
    func testSignatureConsistency() {
        let text = "Test message"
        let iterations = 10
        var signatures: [String] = []

        for _ in 0..<iterations {
            signatures.append(GoogleSignature.generateTK(for: text))
        }

        let uniqueSignatures = Set(signatures)
        #expect(uniqueSignatures.count == 1)
    }

    @Test("Multi-language signature generation")
    func testMultiLanguageSignature() {
        let inputs = [
            "Hello World",
            "Bonjour le monde",
            "Hallo Welt",
            "世界你好"
        ]
        var signatures: [String] = []
        for input in inputs {
            signatures.append(GoogleSignature.generateTK(for: input))
        }
        #expect(!signatures.allSatisfy { $0.isEmpty })
    }
}
