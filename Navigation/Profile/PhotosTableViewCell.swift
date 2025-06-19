//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Лисин Никита on 11.06.2025.
//

import Foundation
import UIKit

protocol PhotosTableViewCellDelegate: AnyObject {
    func photosTableViewCellDidTap(_ cell: PhotosTableViewCell)
}

final class PhotosTableViewCell: UITableViewCell {
    
    static let identifier = "PhotosTableViewCell"
    weak var delegate: PhotosTableViewCellDelegate?
    // MARK: - UI Components
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.text = "Photos"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.right")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var photos: [UIImage] = []
    let photoNames = [
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fithteen", "sixteen", "seventeen", "eighteen", "nineteen", "twenty"
        ]


    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        loadPhotos()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(photoLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                photoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                photoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                
                arrowImageView.centerYAnchor.constraint(equalTo: photoLabel.centerYAnchor),
                arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                arrowImageView.widthAnchor.constraint(equalToConstant: 24),
                arrowImageView.heightAnchor.constraint(equalToConstant: 24),
                
                collectionView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 12),
                collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
                collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.25)
            ])
        }
    
    private func loadPhotos() {
        photos = photoNames.compactMap { UIImage(named: $0)}
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        delegate?.photosTableViewCellDidTap(self)
    }
}


// MARK: - UICollectionView DataSource
extension PhotosTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, photos.count) 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing: CGFloat = 8 * 3
        let availableWidth = collectionView.bounds.width - totalHorizontalSpacing
        let sideLength = availableWidth / 4
        return CGSize(width: sideLength, height: sideLength)
    }
}




// MARK: - PhotoCollectionViewCell
final class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 6
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
