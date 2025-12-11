//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 28.05.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ProfileViewModelProtocol!
    private var state: ProfileViewState = .loading {
        didSet {
            updateUI(for: state)
        }
    }
    
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
    
    private let debugLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var animatingAvatar: UIImageView?
    private var overlayView: UIView?
    private var closeButton: UIButton?
    
    // MARK: - Initialization
    convenience init(viewModel: ProfileViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.handleEvent(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(debugLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            debugLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            debugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            debugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] newState in
            DispatchQueue.main.async {
                self?.state = newState
            }
        }
        
        viewModel.onAvatarAnimation = { [weak self] event in
            DispatchQueue.main.async {
                self?.handleAvatarAnimation(event)
            }
        }
    }
    
    // MARK: - UI Updates
    private func updateUI(for state: ProfileViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            tableView.isHidden = true
            debugLabel.isHidden = true
            
        case .loaded(let user, _, let debugInfo):
            activityIndicator.stopAnimating()
            tableView.isHidden = false
            
            setupNavigationBar(with: user.fullName)
            
            setupDebugInfo(debugInfo)
            
            tableView.reloadData()
            
        case .error(let message):
            activityIndicator.stopAnimating()
            showErrorAlert(message: message)
        }
    }
    
    private func setupNavigationBar(with userName: String) {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        #if DEBUG
        title = "\(userName) [DEBUG]"
        #else
        title = userName
        #endif
    }
    
    private func setupDebugInfo(_ info: String) {
        #if DEBUG
        debugLabel.text = info
        debugLabel.isHidden = false
        #else
        debugLabel.isHidden = true
        #endif
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Avatar Animation Handling
    private func handleAvatarAnimation(_ event: AvatarAnimationEvent) {
        switch event {
        case .startAnimation(let avatarImageView, let originalFrame):
            startAvatarAnimation(avatarImageView: avatarImageView, originalFrame: originalFrame)
            
        case .addCloseButton(let window):
            addCloseButton(to: window)
            
        case .finishAnimation:
            finishAvatarAnimation()
        }
    }
    
    private func startAvatarAnimation(avatarImageView: UIImageView, originalFrame: CGRect) {
        guard let window = view.window else { return }
        
        animatingAvatar = UIImageView(image: avatarImageView.image)
        animatingAvatar?.contentMode = .scaleAspectFill
        animatingAvatar?.clipsToBounds = true
        animatingAvatar?.layer.cornerRadius = avatarImageView.layer.cornerRadius
        animatingAvatar?.frame = originalFrame
        
        if let animatingAvatar = animatingAvatar {
            window.addSubview(animatingAvatar)
        }
        
        overlayView = UIView(frame: window.bounds)
        overlayView?.backgroundColor = .black
        overlayView?.alpha = 0
        
        if let overlayView = overlayView, let animatingAvatar = animatingAvatar {
            window.insertSubview(overlayView, belowSubview: animatingAvatar)
        }
        
        // Анимация
        let safeWidth = window.bounds.width - 40
        let aspectRatio = avatarImageView.bounds.height / avatarImageView.bounds.width
        let targetHeight = safeWidth * aspectRatio
        let targetY = (window.bounds.height - targetHeight) / 2
        
        UIView.animate(withDuration: 0.5, animations: {
            self.animatingAvatar?.frame = CGRect(
                x: 20,
                y: targetY,
                width: safeWidth,
                height: targetHeight
            )
            self.animatingAvatar?.layer.cornerRadius = 0
            self.overlayView?.alpha = 0.7
        }) { _ in
            self.viewModel.onAvatarAnimation?(.addCloseButton(to: window))
        }
    }
    
    private func addCloseButton(to window: UIWindow) {
        closeButton = UIButton(type: .system)
        closeButton?.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton?.tintColor = .white
        closeButton?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton?.layer.cornerRadius = 20
        closeButton?.alpha = 0
        closeButton?.frame = CGRect(
            x: window.bounds.width - 60,
            y: window.safeAreaInsets.top + 20,
            width: 40,
            height: 40
        )
        closeButton?.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        if let closeButton = closeButton {
            window.addSubview(closeButton)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.closeButton?.alpha = 1
        }
    }
    
    @objc private func closeButtonTapped() {
        viewModel.handleEvent(.closeAvatarTapped)
    }
    
    private func finishAvatarAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton?.alpha = 0
        }) { _ in
            self.closeButton?.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.overlayView?.alpha = 0
            }) { _ in
                self.animatingAvatar?.removeFromSuperview()
                self.overlayView?.removeFromSuperview()
                self.animatingAvatar = nil
                self.overlayView = nil
                self.closeButton = nil
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(in: section)
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
            
            if let post = viewModel.getPost(at: indexPath) {
                let post2 = Post2(
                    author: post.author,
                    description: post.description,
                    image: post.imageName,
                    likes: post.likes,
                    views: post.views
                )
                cell.configure(with: post2)
            }
            
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
        guard section == 0, case .loaded(let user, _, _) = state else {
            return nil
        }
        
        let headerView = ProfileHeaderView()
        headerView.delegate = self
        
        // Конвертируем ProfileUser в User для header
        let userForHeader = User(
            login: user.login,
            fullName: user.fullName,
            avatar: user.avatar,
            status: user.status
        )
        
        headerView.configure(with: userForHeader)
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
        viewModel.handleEvent(.photosCellTapped)
        
        let galleryVC = PhotoViewController()
        navigationController?.pushViewController(galleryVC, animated: true)
    }
}

// MARK: - ProfileHeaderViewDelegate
extension ProfileViewController: ProfileHeaderViewDelegate {
    func didTapAvatar(_ avatarImageView: UIImageView) {
        viewModel.handleEvent(.avatarTapped(imageView: avatarImageView))
    }

    func didUpdateStatus(_ newStatus: String) {
        viewModel.handleEvent(.updateStatus(newStatus: newStatus))
    }
}
