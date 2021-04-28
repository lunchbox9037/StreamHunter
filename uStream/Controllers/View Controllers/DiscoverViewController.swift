//
//  TrendingViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/19/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    // MARK: - Sections and Categories
    private enum Section: Int, CaseIterable {
        case trendingMovies
        case trendingTV
        case upcomingMovies
    }
    
    private enum MediaType: String, CaseIterable {
        case movie = "movie"
        case tv = "tv"
    }
    
    private enum Category: String, CaseIterable {
        case trending = "trending"
        case upcoming = "upcoming"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var trendingMovies: [Media] = []
    var trendingMoviePage: Int = 1
    
    var trendingTV: [Media] = []
    var trendingTVPage: Int = 1
    
    var upcomingMovies: [Media] = []
    var upcomingMoviesPage: Int = 1
    
    var totalPages = 1000
    private var isFetchingMore = false

    private var refresher: UIRefreshControl = UIRefreshControl()
    private var dispatchGroup = DispatchGroup()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrendingMedia()
        fetchUpcomingMedia()
        setupRefresher()
        dispatchGroup.notify(queue: .main) {
            self.setupCollectionView()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Methods(
    private func setupCollectionView() {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.systemFill
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "trendingMovieCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "trendingTVCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "upcomingCell")

        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func setupRefresher() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh...")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refresher)
    }//end func
    
    @objc private func loadData() {
        fetchTrendingMedia()
        fetchUpcomingMedia()
        self.trendingMoviePage = 1
        self.trendingTVPage = 1
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadSections([0,1])
            self.refresher.endRefreshing()
        }
    }//end func
    
    func fetchTrendingMedia() {
        for mediaType in MediaType.allCases {
            self.dispatchGroup.enter()
            MediaService().fetch(.trending(mediaType.rawValue, page: 1)) { [weak self] (result: Result<MediaResults, NetError>) in
                switch result {
                case .success(let media):
                    switch mediaType.rawValue {
                    case MediaType.movie.rawValue:
                        self?.trendingMovies = media.results
                        self?.totalPages = media.totalPages
                    case MediaType.tv.rawValue:
                        self?.trendingTV = media.results
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.dispatchGroup.leave()
            }
        }
    }//end func
    
    func fetchUpcomingMedia() {
        self.dispatchGroup.enter()
        MediaService().fetch(.upcomingMovie(page: 1)) { (result: Result<MediaResults, NetError>) in
            switch result {
            case .success(let upcoming):
                self.upcomingMovies = upcoming.results
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.dispatchGroup.leave()
        }
    }//end func
    
    func fetchMore(category: String, mediaType: String, page: Int) {
        switch category {
        case Category.trending.rawValue:
            MediaService().fetch(.trending(mediaType, page: page)) { [weak self] (result: Result<MediaResults, NetError>) in
                switch result {
                case .success(let more):
                    if mediaType == MediaType.movie.rawValue {
                        self?.trendingMovies.append(contentsOf: more.results)
                        self?.trendingMoviePage = more.page
                    }
                    if mediaType == MediaType.tv.rawValue {
                        self?.trendingTV.append(contentsOf: more.results)
                        self?.trendingTVPage = more.page
                    }
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                    self?.isFetchingMore = false
                case .failure(let error):
                    self?.isFetchingMore = false
                    print(error.localizedDescription)
                }
            }
        default:
            self.isFetchingMore = false
            break
        }
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return LayoutBuilder.buildMediaHorizontalScrollLayout()
        }
    }//end func
    
    private func presentDetailVC(media: Media) {
        let detailVC = MediaDetailViewController()
        detailVC.selectedMedia = media
        present(detailVC, animated: true, completion: nil)
    }
}//end class

// MARK: - Extensions
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeader else {return UICollectionReusableView()}
        
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            header.setup(label: "#TrendingMovies")
        case Section.trendingTV.rawValue:
            header.setup(label: "#TrendingShows")
        case Section.upcomingMovies.rawValue:
            header.setup(label: "Upcoming Movies")
        default:
            break
        }
        
        return header
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.trendingMovies.rawValue:
            return trendingMovies.count
        case Section.trendingTV.rawValue:
            return trendingTV.count
        case Section.upcomingMovies.rawValue:
            return upcomingMovies.count
        default:
            return 0
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            switch indexPath.section {
            case Section.trendingMovies.rawValue:
                ImageService().fetchImage(.poster(trendingMovies[indexPath.row].posterPath ?? "")) {(_) in}
            case Section.trendingTV.rawValue:
                ImageService().fetchImage(.poster(trendingTV[indexPath.row].posterPath ?? "")) {(_) in}
            case Section.upcomingMovies.rawValue:
                ImageService().fetchImage(.poster(upcomingMovies[indexPath.row].posterPath ?? "")) {(_) in}
            default:
                break
            }
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingMovieCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            if indexPath.row > trendingMovies.count - 6 && !isFetchingMore && trendingMoviePage < totalPages {
                self.isFetchingMore = true
                self.fetchMore(category: Category.trending.rawValue, mediaType: MediaType.movie.rawValue, page: trendingMoviePage + 1)
            }
            cell.setup(media: trendingMovies[indexPath.row], indexPath: indexPath)
            return cell
            
        case Section.trendingTV.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingTVCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            if indexPath.row > trendingTV.count - 6 && !isFetchingMore && trendingTVPage < totalPages {
                self.isFetchingMore = true
                self.fetchMore(category: Category.trending.rawValue, mediaType: MediaType.tv.rawValue, page: trendingTVPage + 1)
            }
            cell.setup(media: trendingTV[indexPath.row], indexPath: indexPath)
            return cell
            
        case Section.upcomingMovies.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as? MediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setup(media: upcomingMovies[indexPath.row], indexPath: indexPath)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.trendingMovies.rawValue:
            presentDetailVC(media: trendingMovies[indexPath.row])

        case Section.trendingTV.rawValue:
            presentDetailVC(media: trendingTV[indexPath.row])

        case Section.upcomingMovies.rawValue:
            presentDetailVC(media: upcomingMovies[indexPath.row])

        default:
            break
        }
    }
}//end extension

