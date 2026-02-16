//
//  LocalNitificationsService.swift
//  Navigation
//
//  Created by Лисин Никита on 16.02.2026.
//

import UIKit
import UserNotifications

final class LocalNotificationsService: NSObject {
    
    // MARK: - Singleton
    static let shared = LocalNotificationsService()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate.self
    }
    
    // MARK: - Public Methods
    func registeForLatesUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()
        
        // Запрашиваем разрешение на отправку уведомлений
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            if granted {
                print("Разрешение на уведомление получено")
                self?.scheduleDailyUpdateNotification()
            } else if let error = error {
                print("Ошибка при запросе разрешения на уведомления: \(error.localizedDescription)")
            } else {
                print("Пользователь отклонил разрешение на уведомления")
            }
        }
    }
    
    // MARK: - Private Methods
    private func scheduleDailyUpdateNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Создаем контент уведомления
        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        content.badge = 1
        
        // Настраиваем триггер на каждый день в 19:00
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Создаем запрос на уведомление
        let request = UNNotificationRequest(
            identifier: "daily_update_notification",
            content: content,
            trigger: trigger
        )
        
        // Удаляем предыдущие уведомления с таким же идентификатором (если есть)
        center.removePendingNotificationRequests(withIdentifiers: ["daily_update_notification"])
        
        // Добавляем новое уведомление
        center.add(request) { error in
            if let error = error {
                print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
            } else {
                print("Ежедневное уведомление успешно запланировано на 19:00")
                
                // Для отладки: выводим все запланированные уведомления
                self.getPendingNotifications()
            }
        }
    }
    
    private func getPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Запланировано уведомлений: \(requests.count)")
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let nextDate = trigger.nextTriggerDate() {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                    print("Уведомление '\(request.content.body)' запланировано на: \(formatter.string(from: nextDate))")
                }
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    
    // Метод вызывается, когда уведомление доставляется, когда приложение находится на переднем плане
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Показываем уведомление даже когда приложение активно
        completionHandler([.banner, .sound, .badge])
    }
    
    // Метод вызывается, когда пользователь взаимодействует с уведомлением
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Обработка нажатия на уведомление
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            // Пользователь нажал на уведомление
            print("Пользователь открыл приложение через уведомление")
            
            // Здесь можно добавить навигацию к определенному экрану
            NotificationCenter.default.post(name: NSNotification.Name("OpenUpdatesScreen"), object: nil)
            
        default:
            break
        }
        
        completionHandler()
    }
}
