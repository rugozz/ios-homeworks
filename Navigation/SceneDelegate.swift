//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Лисин Никита on 20.05.2025.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        
        // 1. FeedViewController
        let feedViewController = FeedViewController()
        feedViewController.title = "Лента"
        let feedNavController = UINavigationController(rootViewController: feedViewController)
        feedNavController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        
        // 2. LogInViewController
        let loginViewController = LogInViewController()
        
        // Создаем инспектор через фабрику
        let loginFactory = MyLoginFactory()
        let loginInspector = loginFactory.makeLoginInspector()
        
        // Устанавливаем ViewController в инспектор
        if let inspector = loginInspector as? LoginInspector {
            inspector.setViewController(loginViewController)
        }
        
        loginViewController.loginDelegate = loginInspector
        
        let profileNavController = UINavigationController(rootViewController: loginViewController)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        profileNavController.navigationBar.isHidden = true
        
        // 3. MapViewController
        let mapViewController = MapViewController()
        mapViewController.title = "Карта"
        
        let mapNavController = UINavigationController(rootViewController: mapViewController)
        mapNavController.tabBarItem = UITabBarItem(
            title: "Карта",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )
        
        // Настраиваем TabBarController
        tabBarController.viewControllers = [feedNavController, profileNavController, mapNavController]
        
        // Настраиваем внешний вид TabBar
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        // Настраиваем цвет иконок
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        // Настраиваем окно
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
        
        print("✅ TabBarController создан")
        
        // Network request
        let appConfiguration = AppConfiguration.random
        print("\nЗадание: Случайная конфигурация")
        print("Выбрана: \(appConfiguration.description)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NetworkService.request(for: appConfiguration)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        signOutUser()
    }
    
    func sceneWillTerminate(_ scene: UIScene) {
        signOutUser()
    }
    
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "currentUserEmail")
            UserDefaults.standard.removeObject(forKey: "currentUserName")
            print("Пользователь успешно разлогинен")
        } catch {
            print("Ошибка при разлогине: \(error.localizedDescription)")
        }
    }
}
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

