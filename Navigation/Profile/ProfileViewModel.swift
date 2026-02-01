//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Лисин Никита on 11.12.2025.
//

import UIKit
import Combine

// MARK: - Модели данных
struct ProfileUser {
    let login: String
    let fullName: String
    let avatar: UIImage?
    let status: String
}

struct ProfilePost {
    let author: String
    let description: String
    let imageName: String
    let likes: Int
    let views: Int
}

// MARK: - Состояния ViewModel
enum ProfileViewState {
    case loading
    case loaded(user: ProfileUser, posts: [ProfilePost], debugInfo: String)
    case error(message: String)
}

// MARK: - События от View
enum ProfileViewEvent {
    case viewDidLoad
    case avatarTapped(imageView: UIImageView)
    case closeAvatarTapped
    case photosCellTapped
    case updateStatus(newStatus: String)
}

// MARK: - Протокол ViewModel
protocol ProfileViewModelProtocol: AnyObject {
    var onStateChanged: ((ProfileViewState) -> Void)? { get set }
    var onAvatarAnimation: ((AvatarAnimationEvent) -> Void)? { get set }
    func handleEvent(_ event: ProfileViewEvent)
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func getPost(at indexPath: IndexPath) -> ProfilePost?
}

// MARK: - События анимации аватара
enum AvatarAnimationEvent {
    case startAnimation(avatarImageView: UIImageView, originalFrame: CGRect)
    case addCloseButton(to: UIWindow)
    case finishAnimation
}

// MARK: - Реализация ViewModel
class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - Properties
    private let userService: UserService
    private let login: String
    private var user: ProfileUser?
    private var posts: [ProfilePost] = []
    private var debugInfo: String = ""
    
    private var animatingAvatar: UIImageView?
    private var overlayView: UIView?
    private var closeButton: UIButton?
    private var originalAvatarFrame: CGRect = .zero
    
    // MARK: - Callbacks
    var onStateChanged: ((ProfileViewState) -> Void)?
    var onAvatarAnimation: ((AvatarAnimationEvent) -> Void)?
    
    // MARK: - Initialization
    init(userService: UserService, login: String) {
        self.userService = userService
        self.login = login
        setupMockData()
    }
    
    // MARK: - Public Methods
    func handleEvent(_ event: ProfileViewEvent) {
        switch event {
        case .viewDidLoad:
            loadProfileData()
            
        case .avatarTapped(let imageView):
            handleAvatarTap(imageView)
            
        case .closeAvatarTapped:
            handleCloseAvatarTap()
            
        case .photosCellTapped:
            print("Photos cell tapped")
            
        case .updateStatus(let newStatus):
            updateUserStatus(newStatus)
        }
    }
    
    func getNumberOfSections() -> Int {
        return 2
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return posts.count
        default: return 0
        }
    }
    
    func getPost(at indexPath: IndexPath) -> ProfilePost? {
        guard indexPath.section == 1, indexPath.row < posts.count else {
            return nil
        }
        return posts[indexPath.row]
    }
    
    // MARK: - Private Methods
    private func loadProfileData() {
        onStateChanged?(.loading)
        
        // Загружаем пользователя через сервис
        guard let user = userService.getUser(by: login) else {
            onStateChanged?(.error(message: "Пользователь не найден"))
            return
        }
        
        // Конвертируем User в ProfileUser
        let profileUser = ProfileUser(
            login: user.login,
            fullName: user.fullName,
            avatar: user.avatar,
            status: user.status
        )
        
        self.user = profileUser
        
        // Настраиваем debug информацию
        #if DEBUG
        debugInfo = "Debug сборка - Тестовый пользователь"
        #else
        debugInfo = "Release сборка - Продакшен пользователь"
        #endif
        
        // Обновляем состояние
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.onStateChanged?(.loaded(
                user: profileUser,
                posts: self.posts,
                debugInfo: self.debugInfo
            ))
        }
    }
    
    private func handleAvatarTap(_ imageView: UIImageView) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        originalAvatarFrame = imageView.convert(imageView.bounds, to: window)
        animatingAvatar = UIImageView(image: imageView.image)
        
        onAvatarAnimation?(.startAnimation(
            avatarImageView: imageView,
            originalFrame: originalAvatarFrame
        ))
    }
    
    private func handleCloseAvatarTap() {
        guard animatingAvatar != nil, overlayView != nil else { return }
        
        onAvatarAnimation?(.finishAnimation)
        
        animatingAvatar = nil
        overlayView = nil
        closeButton = nil
    }
    
    private func updateUserStatus(_ newStatus: String) {
        guard let currentUser = user else { return }
        
        let updatedUser = ProfileUser(
            login: currentUser.login,
            fullName: currentUser.fullName,
            avatar: currentUser.avatar,
            status: newStatus
        )
        
        self.user = updatedUser
        
        onStateChanged?(.loaded(
            user: updatedUser,
            posts: posts,
            debugInfo: debugInfo
        ))
    }
    
    private func setupMockData() {
        posts = [
            ProfilePost(
                author: "Travaler_55672",
                description: "Удивительный закат на Пхукете! От путешествия я получаю незабываемые эмоции!",
                imageName: "phuket",
                likes: 367,
                views: 1589
            ),
            ProfilePost(
                author: "IOS-Developer_1128",
                description: "Новый МакБук - невероятный!",
                imageName: "macbook",
                likes: 155,
                views: 649
            ),
            ProfilePost(
                author: "I_Love_Eat",
                description: "Домашняя пицца с моцареллой и базиликом. Рецепт в комментариях! 🍕",
                imageName: "pizza",
                likes: 267,
                views: 989
            ),
            ProfilePost(
                author: "Fitness_Coach",
                description: "Утренняя пробежка — лучший способ начать день!",
                imageName: "run",
                likes: 347,
                views: 1459
            )
        ]
    }
}
