//
//  TrendingViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/19/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    // MARK: - Properties
    let trendingMovieSection: [Int] = [0]
    let trendingTVSection: [Int] = [1]
    let trendingPeopleSection: [Int] = [2]
    
    var trendingMovies: [Media] = []
    var trendingTV: [Media] = []
    var trendingPeople: [Person] = []
    let mediaTypes: [String] = ["movie", "tv"]
    
    // MARK: - Views
    lazy var topBar: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemFill
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.backgroundColor = UIColor.red
        return button
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.makeLayout())
        collectionView.backgroundColor = UIColor.systemFill
        collectionView.isPrefetchingEnabled = true
//        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrendingMediaCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        collectionView.register(TrendingMediaCollectionViewCell.self, forCellWithReuseIdentifier: "tvCell")
        collectionView.register(TrendingPeopleCollectionViewCell.self, forCellWithReuseIdentifier: "peopleCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Methods
    func setupViews() {
        fetchTrendingMedia()
        fetchTrendingPeople()
        
        self.view.addSubview(self.topBar)
        self.topBar.addSubview(self.searchButton)
        self.topBar.addSubview(self.logoImageView)
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.topBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.topBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.topBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.topBar.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08)
        ])
        
        NSLayoutConstraint.activate([
            self.logoImageView.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            self.logoImageView.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 0),
            self.logoImageView.heightAnchor.constraint(equalTo: topBar.heightAnchor, multiplier: 1),
            self.logoImageView.widthAnchor.constraint(equalTo: topBar.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            self.searchButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            self.searchButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: 0),
            self.searchButton.heightAnchor.constraint(equalTo: topBar.heightAnchor, multiplier: 1),
            self.searchButton.widthAnchor.constraint(equalTo: topBar.widthAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topBar.bottomAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }//end func
    
    func fetchTrendingMedia() {
        TrendingMediaController.fetchTrendingResultsFor(mediaType: "movie") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let trending):
                    self.trendingMovies = trending.results
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        TrendingMediaController.fetchTrendingResultsFor(mediaType: "tv") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let trending):
                    self.trendingTV = trending.results
                    self.collectionView.reloadSections(IndexSet(integer: 1))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
    
    func fetchTrendingPeople() {
        TrendingPeopleController.fetchTrendingPeople() { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let trending):
                    self.trendingPeople = trending
                    self.collectionView.reloadSections(IndexSet(integer: 2))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
    
    func makeLayout() -> UICollectionViewLayout {
        print("called")
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if self.trendingMovieSection.contains(section) {
                return LayoutBuilder.buildMediaHorizontalScrollLayout(size: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .fractionalHeight(0.25)))
            } else if self.trendingTVSection.contains(section) {
                return LayoutBuilder.buildMediaHorizontalScrollLayout(size: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .fractionalHeight(0.25)))
            } else {
                return LayoutBuilder.buildPeopleIconLayout()
            }
        }
        return layout
    }//end func
    
    func presentDetailVC(media: Media) {
        let detailVC = MediaDetailViewController()
        detailVC.selectedMedia = media
        present(detailVC, animated: true, completion: nil)
    }
}//end class

// MARK: - Extentions
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeader else {return UICollectionReusableView()}
        
        if trendingMovieSection.contains(indexPath.section) {
            header.setup(label: "#TrendingMovies")
        }
        
        if trendingTVSection.contains(indexPath.section) {
            header.setup(label: "#TrendingTV")
        }
        
        if trendingPeopleSection.contains(indexPath.section) {
            header.setup(label: "#TrendingPeople")
        }
        
        return header
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trendingMovieSection.contains(section) {
            return trendingMovies.count
        }
        
        if trendingTVSection.contains(section) {
            return trendingTV.count
        }
        
        if trendingPeopleSection.contains(section) {
            return trendingPeople.count
        }
        return 0
    }//end func
    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            if trendingMovieSection.contains(indexPath.section) {
//                print("fetchedMovie")
//
//                TrendingMediaController.fetchPosterFor(media: trendingMovies[indexPath.row]) { (_) in }
//            }
//            if trendingTVSection.contains(indexPath.section) {
//                print("fetchedTv")
//
//                TrendingMediaController.fetchPosterFor(media: trendingTV[indexPath.row]) { (_) in }
//            }
//            if trendingPeopleSection.contains(indexPath.section) {
//                print("fetchedPEop")
//
//                TrendingPeopleController.fetchPosterFor(person: trendingPeople[indexPath.row]) { (_) in }
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if trendingMovieSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? TrendingMediaCollectionViewCell
            else {return UICollectionViewCell()}
            self.setupCell(cell: cell, media: trendingMovies[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        if trendingTVSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as? TrendingMediaCollectionViewCell else {return UICollectionViewCell()}
            self.setupCell(cell: cell, media: trendingTV[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        if trendingPeopleSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "peopleCell", for: indexPath) as? TrendingPeopleCollectionViewCell else {return UICollectionViewCell()}
            cell.setupCell(person: trendingPeople[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }//end func
    
    func setupCell(cell: TrendingMediaCollectionViewCell, media: Media, indexPath: IndexPath) {
        TrendingMediaController.fetchPosterFor(media: media) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell.posterImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if trendingMovieSection.contains(indexPath.section) {
            presentDetailVC(media: trendingMovies[indexPath.row])
        }
        if trendingTVSection.contains(indexPath.section) {
            presentDetailVC(media: trendingTV[indexPath.row])
        }
    }
}//end extension

//extension TrendingViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("fetched")
//        for indexPath in indexPaths {
//            if trendingMovieSection.contains(indexPath.section) {
//                print("fetched")
//                TrendingMediaController.fetchPosterFor(media: trendingMovies[indexPath.row]) { (_) in }
//            }
//            if trendingTVSection.contains(indexPath.section) {
//                print("fetched")
//
//                TrendingMediaController.fetchPosterFor(media: trendingTV[indexPath.row]) { (_) in }
//            }
//            if trendingPeopleSection.contains(indexPath.section) {
//                print("fetched")
//
//                TrendingPeopleController.fetchPosterFor(person: trendingPeople[indexPath.row]) { (_) in }
//            }
//        }
//
//        var media: Media? = nil
//        var person: Person? = nil
//        switch indexPath.section {
//        case 0:
//            media = trendingMovies[indexPath.row]
//        case 1:
//            media = trendingTV[indexPath.row]
//        case 2:
//            person = trendingPeople[indexPath.row]
//        default:
//            break
//        }
//        if let unwrappedMedia = media {
//            print("prefetched")
//            TrendingMediaController.fetchPosterFor(media: unwrappedMedia) { (_) in }
//        } else if let unwrappedPerson = person {
//            print("wemade it")
//            TrendingPeopleController.fetchPosterFor(person: unwrappedPerson) { (_) in }
//        }
//    }
//}
