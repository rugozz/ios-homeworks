//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit


final class ProfileViewController: UIViewController {
    
    var user: User?
    var debugInfo: String = ""
    
    private var animatingAvatar: UIImageView?
    private var overlayView: UIView?
    private var closeButton: UIButton?
    private var originalAvatarFrame: CGRect = .zero
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // Добавляем label для отладочной информации
    private let debugLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    

    // MARK: - Properties
    
    private let posts: [Post2] = [
        Post2(
            author: "Travaler_55672",
            description: "Удивительный закат на Пхукете! От путешествия я получаю незабываемые эмоции!",
            image: "phuket",
            likes: 367,
            views: 1589
        ),
        
        Post2(
            author: "IOS-Developer_1128",
            description: "Новый МакБук - невероятный!",
            image: "macbook",
            likes: 155,
            views: 649
        ),
        
        Post2(
            author: "I_Love_Eat",
            description: "Домашняя пицца с моцареллой и базиликом. Рецепт в комментариях! 🍕",
            image: "pizza",
            likes: 267,
            views: 989
        ),
        
        Post2(
            author: "Fitness_Coach",
            description: "Утренняя пробежка — лучший способ начать день!",
            image: "run",
            likes: 347,
            views: 1459
        ),
    ]

    
    // MARK: - Lifecycle


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupDebugInfo()
                
                #if DEBUG
                view.backgroundColor = .systemRed.withAlphaComponent(0.1) // Легкий красный фон для Debug
                #else
                view.backgroundColor = .systemBackground
                #endif
    }

    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(debugLabel)
        
        NSLayoutConstraint.activate([
            // Debug label
            debugLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            debugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            debugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            // TableView
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
       
        // Устанавливаем имя пользователя в заголовок с индикатором сборки
        #if DEBUG
        title = "\(user?.fullName ?? "Профиль") [DEBUG]"
        #else
        title = user?.fullName ?? "Профиль"
        #endif
    }
    
    private func setupDebugInfo() {
        #if DEBUG
        debugLabel.text = debugInfo
        debugLabel.isHidden = false
        #else
        debugLabel.isHidden = true
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UITableViewDatasource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return posts.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotosTableViewCell.identifier,
                for: indexPath
            ) as! PhotosTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PostTableViewCell.identifier,
                for: indexPath
            ) as! PostTableViewCell
            cell.configure(with: posts[indexPath.row])
            cell.selectionStyle = .none
            return cell
            
        default:
            fatalError("Unexpected section index")
        }
    }
}
// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let headerView = ProfileHeaderView()
        headerView.delegate = self
        
        // Настраиваем header с информацией о пользователе
        if let user = user {
            headerView.configure(with: user)
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return 220
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 160
        case 1: return UITableView.automaticDimension
        default: return 0
        }
    }
        
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 120
        case 1: return 400
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - PhotosTableViewCellDelegate
extension ProfileViewController: PhotosTableViewCellDelegate {
    func photosTableViewCellDidTap(_ cell: PhotosTableViewCell) {
        let galleryVC = PhotoViewController()
        navigationController?.pushViewController(galleryVC, animated: true)
    }

}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func didTapAvatar(_ avatarImageView: UIImageView) {
        // Получаем frame относительно окна, а не view
        guard let window = view.window else { return }
        originalAvatarFrame = avatarImageView.convert(avatarImageView.bounds, to: window)
        
        // Создаем новое окно для анимации
        let animatingAvatar = UIImageView(image: avatarImageView.image)
        animatingAvatar.contentMode = .scaleAspectFill
        animatingAvatar.clipsToBounds = true
        animatingAvatar.layer.cornerRadius = avatarImageView.layer.cornerRadius
        animatingAvatar.frame = originalAvatarFrame
        window.addSubview(animatingAvatar)
        self.animatingAvatar = animatingAvatar
        
        // Overlay на все окно
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = .black
        overlay.alpha = 0
        window.insertSubview(overlay, belowSubview: animatingAvatar)
        self.overlayView = overlay
        
        // Рассчитываем размер с учетом safeArea
        let safeWidth = window.bounds.width - 40
        let aspectRatio = avatarImageView.bounds.height / avatarImageView.bounds.width
        let targetHeight = safeWidth * aspectRatio
        let targetY = (window.bounds.height - targetHeight) / 2
        
        UIView.animate(withDuration: 0.5, animations: {
            animatingAvatar.frame = CGRect(
                x: 20,
                y: targetY,
                width: safeWidth,
                height: targetHeight
            )
            animatingAvatar.layer.cornerRadius = 0
            overlay.alpha = 0.7
        }) { _ in
            self.addCloseButton(to: window)
        }
    }
    
    private func addCloseButton(to window: UIWindow) {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.frame = CGRect(
            x: window.bounds.width - 60,
            y: window.safeAreaInsets.top + 20,
            width: 40,
            height: 40
        )
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        window.addSubview(button)
        self.closeButton = button
        
        UIView.animate(withDuration: 0.3) {
            button.alpha = 1
        }
    }
    
    @objc private func closeButtonTapped() {
        guard let window = view.window,
              let animatingAvatar = animatingAvatar,
              let overlay = overlayView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton?.alpha = 0
        }) { _ in
            self.closeButton?.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5, animations: {
                animatingAvatar.frame = self.originalAvatarFrame
                animatingAvatar.layer.cornerRadius = self.originalAvatarFrame.width / 2
                overlay.alpha = 0
            }) { _ in
                animatingAvatar.removeFromSuperview()
                overlay.removeFromSuperview()
                self.animatingAvatar = nil
                self.overlayView = nil
                self.closeButton = nil
            }
        }
    }
}
