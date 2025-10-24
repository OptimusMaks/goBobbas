import Foundation

struct Config {
    static let openAIAPIKey: String = {
        // Попробуем получить ключ из переменных окружения
        if let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] {
            return apiKey
        }
        
        // Если переменная окружения не установлена, используем пустую строку
        // В продакшене это должно быть установлено через переменные окружения
        return ""
    }()
    
    static var hasValidAPIKey: Bool {
        return !openAIAPIKey.isEmpty
    }
}
