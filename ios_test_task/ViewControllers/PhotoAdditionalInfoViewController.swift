//
//  PhotoAdditionalInfoViewController.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import UIKit


final class PhotoAdditionalInfoViewController: UIViewController {
        
    private var model: AdditionalPhotoInfo
    
    private let favoriteService: FavoritePhotoServiceProtocol = FavoritePhotoService.shared
    
    init(with photoInfo: AdditionalPhotoInfo) {
        model = photoInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAdditionInfoView(with: model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupRightBarButtonItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    private lazy var imageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var publicationDateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var downloadsNumberLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()


    private func setupViews() {
        [imageView, authorNameLabel, publicationDateLabel, locationLabel, downloadsNumberLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupRightBarButtonItems() {
        let button = UIButton(type: .custom)
        let isLiked = favoriteService.isLiked(with: model.id)
        button.setImage(UIImage(systemName: isLiked ? "star.fill" : "star"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddToFavorite), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: button),
            UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(didTapShare)
            )
        ]
    }
    
    private func setupLayout() {
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        authorNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25).isActive = true
        publicationDateLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 25).isActive = true
        locationLabel.topAnchor.constraint(equalTo: publicationDateLabel.bottomAnchor, constant: 25).isActive = true
        downloadsNumberLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 25).isActive = true
        
        [authorNameLabel, publicationDateLabel, locationLabel, downloadsNumberLabel].forEach {
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
            $0.widthAnchor.constraint(equalToConstant: view.width - 15).isActive = true
        }
    }
    
    func configureAdditionInfoView(with model: AdditionalPhotoInfo) {
        imageView.sd_setImage(with: URL(string: model.urls["full"] ?? ""), completed: nil)
        authorNameLabel.text = "Author: " + model.user.username + " - " + model.user.name
        publicationDateLabel.text = "Published: " + String(model.created_at.prefix(10))
        downloadsNumberLabel.text = "Downloads: " + String(model.downloads)
        if let city = model.location?.city, let country = model.location?.country {
            locationLabel.text = "Location: " + city + ", " + country
        } else {
            locationLabel.text = "Location: unspecified"
        }
    }

}


extension PhotoAdditionalInfoViewController {
    @objc func didTapShare() {
        guard let url = URL(string: model.urls["full"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapAddToFavorite() {
        let actionSheet = UIAlertController(title: "Photo by \(model.user.username)",
                                            message: "Actions",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        let isLiked = self.favoriteService.isLiked(with: self.model.id)
        actionSheet.addAction(UIAlertAction(title: isLiked ? "Remove from favorite" : "Add to favorite",
                                            style: isLiked ? .destructive : .default,
                                            handler: { [weak self] _ in
            guard let self = self else { return }
            if !isLiked {
                self.favoriteService.markAsLiked(with: self.model)
                DispatchQueue.main.async {
                    self.setupRightBarButtonItems()
                }
            } else {
                self.favoriteService.unlike(with: self.model)
                DispatchQueue.main.async {
                    self.setupRightBarButtonItems()
                }
            }
            
        }))
        present(actionSheet, animated: true, completion: nil)
    }
}
