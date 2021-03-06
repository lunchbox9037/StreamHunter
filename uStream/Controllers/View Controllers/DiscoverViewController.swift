//
//  TrendingViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/19/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    let trendingMovieSection: [Int] = [0]
    let trendingTVSection: [Int] = [1]
    let popularMovieSection: [Int] = [2]
    let popularTVSection: [Int] = [3]
    
    var trendingMovies: [Media] = []
    var trendingTV: [Media] = []
    var popularMovies: [Media] = []
    var popularTV: [Media] = []
    let mediaTypes: [String] = ["movie", "tv"]

    var refresher: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefresher()
        fetchTrendingMedia()
        fetchPopularMedia()
    }
    
    // MARK: - Methods(
    func setupCollectionView() {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.backgroundColor = UIColor.systemFill

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPrefetchingEnabled = true

        collectionView.prefetchDataSource = self
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "trendingMovieCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "trendingTVCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "popularMovieCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "popularTVCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupRefresher() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh...")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refresher)
    }//end func
    
    @objc func loadData() {
        fetchTrendingMedia()
        fetchPopularMedia()
        self.refresher.endRefreshing()
    }//end func
    
    func fetchTrendingMedia() {
        for mediaType in mediaTypes {
            MediaController.fetchTrendingResultsFor(mediaType: mediaType) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let trending):
                        if mediaType == self.mediaTypes[0] {
                            self.trendingMovies = trending.results
                            self.collectionView.reloadSections(IndexSet(integer: 0))
                        }
                        if mediaType == self.mediaTypes[1] {
                            self.trendingTV = trending.results
                            self.collectionView.reloadSections(IndexSet(integer: 1))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }//end func
    
    func fetchPopularMedia() {
        for mediaType in mediaTypes {
            MediaController.fetchPopularResultsFor(mediaType: mediaType) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let popular):
                        if mediaType == self.mediaTypes[0] {
                            self.popularMovies = popular.results
                            self.collectionView.reloadSections(IndexSet(integer: 2))
                        }
                        if mediaType == self.mediaTypes[1] {
                            self.popularTV = popular.results
                            self.collectionView.reloadSections(IndexSet(integer: 3))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }//end func
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return LayoutBuilder.buildMediaHorizontalScrollLayout()
            case 1:
                return LayoutBuilder.buildMediaHorizontalScrollLayout()
            case 2:
                return LayoutBuilder.buildMediaHorizontalScrollLayout()
            case 3:
                return LayoutBuilder.buildMediaHorizontalScrollLayout()
            default:
                return LayoutBuilder.buildMediaVerticalScrollLayout()
            }
        }
    }//end func
    
    func presentDetailVC(media: Media) {
        let detailVC = MediaDetailViewController()
        detailVC.selectedMedia = media
        present(detailVC, animated: true, completion: nil)
    }
}//end class

// MARK: - Extensions
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeader else {return UICollectionReusableView()}
        
        if trendingMovieSection.contains(indexPath.section) {
            header.setup(label: "#TrendingMovies")
        }
        
        if trendingTVSection.contains(indexPath.section) {
            header.setup(label: "#TrendingShows")
        }
        
        if popularMovieSection.contains(indexPath.section) {
            header.setup(label: "Popular Movies")
        }
        
        if popularTVSection.contains(indexPath.section) {
            header.setup(label: "Popular Shows")
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
        
        if popularMovieSection.contains(section) {
            return popularMovies.count
        }
        
        if popularTVSection.contains(section) {
            return popularTV.count
        }
        return 0
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if trendingMovieSection.contains(indexPath.section) {
                MediaController.fetchPosterFor(media: trendingMovies[indexPath.row]) { (_) in }
            }
            if trendingTVSection.contains(indexPath.section) {
                MediaController.fetchPosterFor(media: trendingTV[indexPath.row]) { (_) in }
            }
            if popularMovieSection.contains(indexPath.section) {
                MediaController.fetchPosterFor(media: popularMovies[indexPath.row]) { (_) in }
            }
            if popularTVSection.contains(indexPath.section) {
                MediaController.fetchPosterFor(media: popularTV[indexPath.row]) { (_) in }
            }
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if trendingMovieSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingMovieCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setupCell(media: trendingMovies[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        if trendingTVSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingTVCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setupCell(media: trendingTV[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        if popularMovieSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularMovieCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setupCell(media: popularMovies[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        if popularTVSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularTVCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setupCell(media: popularTV[indexPath.row], indexPath: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if trendingMovieSection.contains(indexPath.section) {
            presentDetailVC(media: trendingMovies[indexPath.row])
        }
        
        if trendingTVSection.contains(indexPath.section) {
            presentDetailVC(media: trendingTV[indexPath.row])
        }
        
        if popularMovieSection.contains(indexPath.section) {
            presentDetailVC(media: popularMovies[indexPath.row])
        }
        
        if popularTVSection.contains(indexPath.section) {
            presentDetailVC(media: popularTV[indexPath.row])
        }
    }
}//end extension

