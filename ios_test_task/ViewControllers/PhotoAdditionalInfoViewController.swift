//
//  PhotoAdditionalInfoViewController.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import UIKit


final class PhotoAdditionalInfoViewController: UIViewController {
        
    private var model: AdditionalPhotoInfo
    
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

