//
//  FavoritePhotosViewController.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import Foundation
import UIKit

final class FavoritePhotosViewController: UIViewController {
    
    private var likedPhotos: [AdditionalPhotoInfo] = []
    
    private let apiService: APIServiceProtocol = APIService.shared
    var coordinator: FavoritePhotoCoordinator!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoritePhotoViewCell.self,
                           forCellReuseIdentifier: FavoritePhotoViewCell.id)
        tableView.separatorColor = .clear
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Favorite",
                                  image: UIImage(systemName: "star.fill"),
                                  selectedImage: nil)
        likedPhotos = FavoritePhotoService.shared.liked
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Photos"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(likesChanged),
                                               name: FavoritePhotoService.notificationKey,
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    @objc private func likesChanged() {
        debugPrint(#function)
        likedPhotos = FavoritePhotoService.shared.liked
        tableView.reloadData()
    }
}


extension FavoritePhotosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotoViewCell.id,
                                                       for: indexPath) as? FavoritePhotoViewCell else {
            return UITableViewCell()
        }
        let model = likedPhotos[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped cell")
        let current = likedPhotos[indexPath.item]
        self.coordinator?.showAdditionalInfo(with: current)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = likedPhotos[indexPath.item]
            FavoritePhotoService.shared.unlike(with: itemToDelete)
        }
    }
    
}
