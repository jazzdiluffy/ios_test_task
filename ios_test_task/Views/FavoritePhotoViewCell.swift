//
//  FavoritePhotoViewCell.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 13.01.2022.
//

import UIKit
import SDWebImage


final class FavoritePhotoViewCell: UITableViewCell {
    
    static let id = "FavoritePhotoViewCell"
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(authorLabel)
    }
    
    private func setupLayout() {
        thumbImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        thumbImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        thumbImageView.heightAnchor.constraint(equalToConstant: contentView.height - 10).isActive = true
        thumbImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/10).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: thumbImageView.rightAnchor, constant: 10).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 5/10).isActive = true
    }
    
    func configure(with model: AdditionalPhotoInfo) {
        let imageURL = model.urls["thumb"]
        thumbImageView.sd_setImage(with: URL(string: imageURL ?? ""), completed: nil)
        authorLabel.text = "Author: \(model.user.username) - \(model.user.name)"
    }
}
