//
//  FeedModel.swift
//  Navigation
//
//  Created by Лисин Никита on 11.12.2025.
//

import Foundation

class FeedModel {
    
    // Загаданное слово
    private let secretWord = "Swift"
    
    // Счетчик попыток
    private(set) var attemptsCount = 0
    
    // Closure для обработки результата проверки
    var onWordCheckResult: ((Bool, String) -> Void)?
    
    // Метод проверки слова
    func check(word: String) {
        // Проверка на пустую строку
        guard !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onWordCheckResult?(false, "Введите слово")
            return
        }
        
        // Увеличиваем счетчик попыток
        attemptsCount += 1
        
        // Приводим к одному регистру для сравнения
        let normalizedInput = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let normalizedSecret = secretWord.lowercased()
        
        // Проверяем соответствие
        let isCorrect = normalizedInput == normalizedSecret
        
        // Формируем сообщение
        let message = isCorrect
            ? "Правильно! Загаданное слово: \(secretWord)"
            : "Неверно. Попыток: \(attemptsCount)"
        
        // Отправляем результат
        onWordCheckResult?(isCorrect, message)
    }
    
    // Сброс 
    func resetGame() {
        attemptsCount = 0
    }
}
