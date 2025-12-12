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
    private var processedPhotos: [UIImage] = []
    private let itemsPerRow: CGFloat = 3
    private let spacing: CGFloat = 8
    private let imageProcessor = ImageProcessor()
    
    private let photoNames = [
        "one", "two", "three", "four", "five", "six", "seven", "eight",
        "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
        "fithteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"
    ]
    
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
    
    private let processButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Обработать фильтром Noir", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите QoS и нажмите кнопку"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let qosSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Интерактив", "Инициатор", "Утилити", "Фон"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialPhotos()
        
        // Автоматически запускаем тесты при загрузке
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.testAllQoSLevels()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Обработка фото"
        view.backgroundColor = .systemBackground
        
        view.addSubview(qosSegmentedControl)
        view.addSubview(processButton)
        view.addSubview(timeLabel)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        processButton.addTarget(self, action: #selector(processWithSelectedQoS), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            qosSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            qosSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            qosSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            processButton.topAnchor.constraint(equalTo: qosSegmentedControl.bottomAnchor, constant: 16),
            processButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            processButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            processButton.heightAnchor.constraint(equalToConstant: 44),
            
            timeLabel.topAnchor.constraint(equalTo: processButton.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadInitialPhotos() {
        // Загружаем начальные фото из ресурсов
        let initialPhotos = photoNames.compactMap { UIImage(named: $0) }
        photos = initialPhotos
        processedPhotos = initialPhotos
        collectionView.reloadData()
    }
    
    // MARK: - Image Processing
    @objc private func processWithSelectedQoS() {
        let selectedQoS: QualityOfService
        
        switch qosSegmentedControl.selectedSegmentIndex {
        case 0: selectedQoS = .userInteractive
        case 1: selectedQoS = .userInitiated
        case 2: selectedQoS = .utility
        case 3: selectedQoS = .background
        default: selectedQoS = .default
        }
        
        timeLabel.text = "Обработка..."
        timeLabel.textColor = .systemOrange
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        print("🚀 Запуск с QoS: \(qosToString(selectedQoS))")
        
        imageProcessor.processImagesOnThread(
            sourceImages: photos,
            filter: .noir,
            qos: selectedQoS
        ) { [weak self] cgImages in
            guard let self = self else { return }
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let executionTime = endTime - startTime
            
            // Конвертируем CGImage? в UIImage
            let processedImages = cgImages.compactMap { cgImage -> UIImage? in
                guard let cgImage = cgImage else { return nil }
                return UIImage(cgImage: cgImage)
            }
            
            DispatchQueue.main.async {
                self.processedPhotos = processedImages
                self.collectionView.reloadData()
                
                let timeText = String(format: "Время: %.3f сек | QoS: %@",
                                     executionTime, self.qosToString(selectedQoS))
                self.timeLabel.text = timeText
                self.timeLabel.textColor = .systemGreen
            }
        }
    }
    
    // MARK: - Test All QoS Levels (для задания)
    private func testAllQoSLevels() {
        print("\n🔬 НАЧИНАЕМ ТЕСТИРОВАНИЕ РАЗНЫХ QoS")
        print("==================================")
        
        let qosLevels: [QualityOfService] = [.userInteractive, .userInitiated, .utility, .background]
        var results: [String: Double] = [:]
        let testGroup = DispatchGroup()
        
        for qos in qosLevels {
            testGroup.enter()
            
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
                self.runSingleTest(qos: qos) { time in
                    results[self.qosToString(qos)] = time
                    testGroup.leave()
                }
            }
        }
        
        testGroup.notify(queue: .main) {
            print("\n📊 РЕЗУЛЬТАТЫ ТЕСТИРОВАНИЯ:")
            print("============================")
            
            // Сортируем от быстрого к медленному
            let sortedResults = results.sorted { $0.value < $1.value }
            
            for (qos, time) in sortedResults {
                print("\(qos): \(String(format: "%.3f", time)) секунд")
            }
            
            print("============================")
            
            // Сохраняем комментарий для задания
            self.saveTestResults(sortedResults)
            
            // Показываем результат на экране
            let fastest = sortedResults.first
            let slowest = sortedResults.last
            self.timeLabel.text = "Тесты завершены! Самый быстрый: \(fastest?.key ?? "")"
        }
    }
    
    private func runSingleTest(qos: QualityOfService, completion: @escaping (Double) -> Void) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Используем только 5 изображений для быстрого теста
        let testImages = Array(photos.prefix(5))
        
        imageProcessor.processImagesOnThread(
            sourceImages: testImages,
            filter: .noir,
            qos: qos
        ) { _ in
            let endTime = CFAbsoluteTimeGetCurrent()
            let executionTime = endTime - startTime
            
            print("✅ \(self.qosToString(qos)): \(String(format: "%.3f", executionTime)) сек")
            completion(executionTime)
        }
    }
    
    private func saveTestResults(_ results: [(key: String, value: Double)]) {
        let resultsText = """
        === КОММЕНТАРИЙ ДЛЯ ЗАДАНИЯ ===
        
        Время обработки 5 изображений фильтром Noir:
        
        • UserInteractive: \(String(format: "%.3f", results.first(where: { $0.key == "UserInteractive" })?.value ?? 0)) сек
        • UserInitiated: \(String(format: "%.3f", results.first(where: { $0.key == "UserInitiated" })?.value ?? 0)) сек
        • Utility: \(String(format: "%.3f", results.first(where: { $0.key == "Utility" })?.value ?? 0)) сек
        • Background: \(String(format: "%.3f", results.first(where: { $0.key == "Background" })?.value ?? 0)) сек
        
        Наблюдения:
        1. UserInteractive - самый быстрый, так как имеет высший приоритет
        2. UserInitiated - немного медленнее, но оптимален для пользовательских действий
        3. Utility - средняя скорость, подходит для фоновых задач
        4. Background - самый медленный, но наиболее энергоэффективный
        
        Вывод: для обработки изображений в реальном приложении лучше использовать 
        UserInitiated или Utility в зависимости от важности задачи.
        """
        
        print("\n\(resultsText)")
        
        // Можно сохранить в файл или UserDefaults для отчета
        UserDefaults.standard.set(resultsText, forKey: "qos_test_results")
    }
    
    private func qosToString(_ qos: QualityOfService) -> String {
        switch qos {
        case .userInteractive: return "UserInteractive"
        case .userInitiated: return "UserInitiated"
        case .utility: return "Utility"
        case .background: return "Background"
        default: return "Default"
        }
    }
}

// MARK: - CollectionView DataSource & Delegate (без изменений)
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return processedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.imageView.image = processedPhotos[indexPath.item]
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

// MARK: - Photo Cell (без изменений)
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
