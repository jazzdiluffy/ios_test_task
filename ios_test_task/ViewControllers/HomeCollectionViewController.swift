//
//  MainViewController.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import UIKit
import CollectionViewWaterfallLayout


final class HomeCollectionViewController: UIViewController {
    
    private var timer: Timer?
    let apiService: APIServiceProtocol = APIService.shared
    var coordinator: HomeCoordinator!
    var searchResults: [Photo] = []
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
        
        for photo in searchResults {
            cellSizes.append(CGSize(width: photo.width, height: photo.height))
        }
        return cellSizes
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        return collectionView
    }()
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search cool free photos ..."
        sc.searchBar.searchBarStyle = .minimal
        sc.definesPresentationContext = true
        return sc
    }()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Main",
                                  image: UIImage(systemName: "photo.artframe"),
                                  selectedImage: nil)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRandomPhotosList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Collection"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension HomeCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (_) in
            guard let searchTerm = searchBar.text else { return }
            self.getSearchResults(with: searchTerm)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getRandomPhotosList()
    }
}

extension HomeCollectionViewController {
    func getRandomPhotosList() {
        apiService.makeRandomPhotosRequest { result in
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self.searchResults = searchResults
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getSearchResults(with searchTerm: String) {
        self.apiService.makeSearchRequest(with: searchTerm) { [weak self] result in
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self?.searchResults = searchResults.results
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.id, for: indexPath) as? PhotoViewCell else { return UICollectionViewCell() }
        let photo = searchResults[indexPath.item]
        cell.settedPhoto = photo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = searchResults[indexPath.item]
        
        apiService.makeAdditionalPhotoInfoRequest(by: current.id) { result in
            switch result {
            case .success(let model):
                self.coordinator?.showAdditionalInfo(with: model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

extension HomeCollectionViewController: CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}
