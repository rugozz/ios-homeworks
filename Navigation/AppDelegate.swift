//
//  AppDelegate.swift
//  Navigation
//
//  Created by Лисин Никита on 20.05.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // Настройка внешнего вида
        configureAppearance()
        
        // Настройка уведомлений
        setupNotifications()
        return true
    }
    // MARK: - Private Methods
    private func configureAppearance() {
        // Настройка Navigation Bar
        UINavigationBar.appearance().tintColor = .systemBlue
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
    }

    private func setupNotifications() {
        // Запрос на отправку уведомлений о последних обновлениях
        LocalNotificationsService.shared.registeForLatesUpdatesIfPossible()
        
        // Подписка на уведомление о открытии через нотификацию
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOpenUpdatesNotification),
            name: NSNotification.Name("OpenUpdatesScreen"),
            object: nil
        )
    }

    @objc private func handleOpenUpdatesNotification() {
        // Обработка открытия приложения через уведомление
        // Например, можно открыть экран с обновлениями
        print("Открытие экрана с обновлениями")
        
        // Здесь можно добавить логику для навигации на экран обновлений
        // Например, через координатор или NotificationCenter
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

