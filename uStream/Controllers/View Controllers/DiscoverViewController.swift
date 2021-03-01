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
    let trendingPeopleSection: [Int] = [2]
    
    var trendingMovies: [Media] = []
    var trendingTV: [Media] = []
    var trendingPeople: [Person] = []
    let mediaTypes: [String] = ["movie", "tv"]

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchTrendingPeople()
        
        setupCollectionView()
        fetchTrendingMedia()

    }
    
    // MARK: - Methods(
    func setupCollectionView() {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.backgroundColor = UIColor.systemFill

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPrefetchingEnabled = true

//        collectionView.prefetchDataSource = self
        collectionView.register(TrendingMediaCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        collectionView.register(TrendingMediaCollectionViewCell.self, forCellWithReuseIdentifier: "tvCell")
        collectionView.register(TrendingPeopleCollectionViewCell.self, forCellWithReuseIdentifier: "peopleCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fetchTrendingMedia() {
        for mediaType in mediaTypes {
            TrendingMediaController.fetchTrendingResultsFor(mediaType: mediaType) { (result) in
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
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return LayoutBuilder.buildMediaHorizontalScrollLayout()
            case 1:
                return LayoutBuilder.buildMediaHorizontalScrollLayout()
            default:
                return LayoutBuilder.buildPeopleIconLayout()
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
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeader else {return UICollectionReusableView()}
        
        if trendingMovieSection.contains(indexPath.section) {
            header.setup(label: "#TrendingMovies")
        }
        
        if trendingTVSection.contains(indexPath.section) {
            header.setup(label: "#TrendingTV")
        }
        
//        if trendingPeopleSection.contains(indexPath.section) {
//            header.setup(label: "#TrendingPeople")
//        }
        
        return header
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trendingMovieSection.contains(section) {
            return trendingMovies.count
        }
        
        if trendingTVSection.contains(section) {
            return trendingTV.count
        }
        
//        if trendingPeopleSection.contains(section) {
//            return trendingPeople.count
//        }
        return 0
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if trendingMovieSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? TrendingMediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setupCell(media: trendingMovies[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        if trendingTVSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvCell", for: indexPath) as? TrendingMediaCollectionViewCell
            else {return UICollectionViewCell()}
            cell.setupCell(media: trendingTV[indexPath.row], indexPath: indexPath)
            return cell
        }
        
//        if trendingPeopleSection.contains(indexPath.section) {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "peopleCell", for: indexPath) as? TrendingPeopleCollectionViewCell else {return UICollectionViewCell()}
//            cell.setupCell(person: trendingPeople[indexPath.row])
//            return cell
//        }
        return UICollectionViewCell()
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

//extension DiscoverViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            if trendingMovieSection.contains(indexPath.section) {
//
//                TrendingMediaController.fetchPosterFor(media: trendingMovies[indexPath.row]) { (_) in }
//            }
//            if trendingTVSection.contains(indexPath.section) {
//
//                TrendingMediaController.fetchPosterFor(media: trendingTV[indexPath.row]) { (_) in }
//            }
////            if trendingPeopleSection.contains(indexPath.section) {
////
////                TrendingPeopleController.fetchPosterFor(person: trendingPeople[indexPath.row]) { (_) in }
////            }
//        }
//    }
//}
