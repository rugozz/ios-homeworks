//
//  PhotoViewController.swift
//  Navigation
//
//  Created by Лисин Никита on 16.06.2025.
//

import UIKit
import iOSIntPackage

final class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    private var photos: [UIImage] = []
    private let itemsPerRow: CGFloat = 3
    private let spacing: CGFloat = 8
    
    private let photoNames = [
        "one", "two", "three", "four", "five", "six", "seven", "eight",
        "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
        "fithteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"
    ]
    
    // ImagePublisherFacade из пакета
    private let imagePublisher = ImagePublisherFacade()
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupImagePublisher()
        loadInitialPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoadingImages()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelSubscription()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Photo Gallery"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func loadInitialPhotos() {
        // Загружаем начальные фото из ресурсов
        let initialPhotos = photoNames.compactMap { UIImage(named: $0) }
        photos = initialPhotos
        collectionView.reloadData()
    }
    
    private func setupImagePublisher() {
        // Подписываем текущий контроллер на обновления изображений
        imagePublisher.subscribe(self)
        print("✅ PhotoViewController подписан на ImagePublisherFacade")
    }
    
    private func startLoadingImages() {
        // Создаем массив с нашими фото для передачи в метод
        let userImages = photoNames.compactMap { UIImage(named: $0) }
        
        // Правильный вызов метода с использованием наших фото
        imagePublisher.addImagesWithTimer(
            time: 0.7,
            repeat: 18,
            userImages: userImages
        )
        
        print("Запущена загрузка изображений с интервалом 0.7 секунд")
        print("Используется \(userImages.count) пользовательских изображений")
    }
    
    private func cancelSubscription() {
        // Отменяем подписку при уходе с экрана
        imagePublisher.removeSubscription(for: self)
        print("🛑 Подписка на ImagePublisher отменена")
    }
}

// MARK: - ImageLibrarySubscriber
extension PhotoViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        photos = images
        collectionView.reloadData()
        
        let item = IndexPath(item: images.count - 1, section: 0)
        collectionView.scrollToItem(at: item, at: .bottom, animated: true)
    }
}

// MARK: - CollectionView DataSource & Delegate
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (itemsPerRow - 1) * spacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let sideLength = availableWidth / itemsPerRow
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
    }
}

// MARK: - Photo Cell
final class PhotoCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
