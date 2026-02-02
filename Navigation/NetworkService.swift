//
//  NetworkService.swift
//  Navigation
//
//  Created by Лисин Никита on 02.02.2026.
//

import UIKit

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        let urlString: String
        
        switch configuration {
        case .people(let url):
            urlString = url
        case .starships(let url):
            urlString = url
        case .planets(let url):
            urlString = url
        }
        
        guard let url = URL(string: urlString) else {
            print("Неверный URL: \(urlString)")
            return
        }
        
        print("Запрашиваем URL: \(urlString)")
        print("Конфигурация: \(configuration.description)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("\n" + String(repeating: "=", count: 50))
            print("Ответ от сервера")
            print(String(repeating: "=", count: 50))
            
            if let error = error {
                let nsError = error as NSError
                print("Ошибка: \(error.localizedDescription)")
                print("Debug описание: \(nsError.debugDescription)")
                print("\n Код ошибки: \(nsError.code)")
                
                DispatchQueue.main.async {
                    showErrorAlert(message: error.localizedDescription)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Статус код: \(httpResponse.statusCode)")
                print("Заголовки ответа:")
                for (key, value) in httpResponse.allHeaderFields {
                    print("   \(key): \(value)")
                }
                print()
            }
            
            if let data = data {
                print("Получено данных: \(data.count) байт")
                
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Данные (UTF-8):")
                    print(dataString.prefix(500))
                    if dataString.count > 500 {
                        print("... (показано 500 из \(dataString.count) символов)")
                    }
                } else {
                    print("Не удалось преобразовать данные в строку UTF-8")
                }
            } else {
                print("Данные не получены")
            }
            
            print(String(repeating: "=", count: 50) + "\n")
            
            DispatchQueue.main.async {
                showSuccessAlert(configuration: configuration)
            }
        }
        
        task.resume()
    }
    
    private static func showErrorAlert(message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "Ошибка сети",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        var presentingController = rootViewController
        while let presented = presentingController.presentedViewController {
            presentingController = presented
        }
        
        presentingController.present(alert, animated: true)
    }
    
    private static func showSuccessAlert(configuration: AppConfiguration) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let title: String
        switch configuration {
        case .people:
            title = "Данные о персонаже"
        case .starships:
            title = "Данные о звездолете"
        case .planets:
            title = "Данные о планете"
        }
        
        let alert = UIAlertController(
            title: title,
            message: "Данные успешно получены из Star Wars API!\nПроверьте консоль для деталей.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        var presentingController = rootViewController
        while let presented = presentingController.presentedViewController {
            presentingController = presented
        }
        
        presentingController.present(alert, animated: true)
    }
}
