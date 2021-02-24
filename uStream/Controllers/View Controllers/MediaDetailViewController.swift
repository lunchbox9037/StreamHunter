//
//  MedaiDetailViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/22/21.
//

import UIKit

class MediaDetailViewController: UIViewController {
    // MARK: - Properties
    var selectedMedia: Media?
    
    let selectedMediaSection: [Int] = [0]
    let whereToWatchSection: [Int] = [1]
    let recommendationsSection: [Int] = [2]
    
    var providers: [Provider] = []
    var recommendations: [Media] = []
    
    // MARK: - Views
    lazy var dismissViewButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .opaqueSeparator
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.makeLayout())
        collectionView.backgroundColor = UIColor.systemGray
        collectionView.delegate = self
        collectionView.dataSource = self
        //register new cells
        collectionView.register(MediaDetailCollectionViewCell.self, forCellWithReuseIdentifier: "mediaDetailCell")
        collectionView.register(WhereToWatchCollectionViewCell.self, forCellWithReuseIdentifier: "providerCell")
        collectionView.register(RecommendationsCollectionViewCell.self, forCellWithReuseIdentifier: "recommendationCell")
        collectionView.register(TrendingSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemGray
        setupViews()
    }
    
    // MARK: - Methods
    func setupViews() {
        fetchWhereToWatch()
        fetchRecommendations()
        self.view.addSubview(self.dismissViewButton)
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.dismissViewButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12),
            self.dismissViewButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12),
            self.dismissViewButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.dismissViewButton.bottomAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if self.selectedMediaSection.contains(section) {
                return LayoutBuilder.buildMediaDetailSection()
            } else if self.whereToWatchSection.contains(section) {
                return LayoutBuilder.buildWhereToWatchIconSection()
            } else {
                return LayoutBuilder.buildMediaHorizontalScrollLayout(size: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .fractionalHeight(0.25)))
            }
        }
        return layout
    }//end func
    
    func fetchWhereToWatch() {
        guard let media = selectedMedia else {return}
        WhereToWatchController.fetchWhereToWatchBy(id: media.id ?? 603, mediaType: media.mediaType ?? "movie") { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let location):
                    self?.providers = location.streaming
                    self?.collectionView.reloadData()
                    print("got providers")
                case .failure(let error):

                    print(error.localizedDescription)
                }
            }
        }
    }//end func
    
    func fetchRecommendations() {
        guard let media = selectedMedia else {return}
        RecommendationsController.fetchRecommendationsFor(mediaType: media.mediaType ?? "movie", id: media.id ?? 603 ) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recommendations):
                    self?.recommendations = recommendations.results
                    self?.collectionView.reloadData()
                    print("got providers")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}//end class

// MARK: - Extensions
extension MediaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedMediaSection.contains(section) {
            return 1
        }
        if whereToWatchSection.contains(section) {
            return providers.count
        }
        if recommendationsSection.contains(section) {
            return recommendations.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrendingSectionHeader else {return UICollectionReusableView()}
        if selectedMediaSection.contains(indexPath.section) {
//            if selectedMedia?.mediaType == "movie" {
//                header.setup(label: self.selectedMedia?.title ?? "Unknown")
//            } else {
//                header.setup(label: self.selectedMedia?.name ?? "Unknown")
//            }
            header.setup(label: (self.selectedMedia?.name ?? self.selectedMedia?.title) ?? "The Matrix")

        }
        
        if whereToWatchSection.contains(indexPath.section) {
            header.setup(label: "Stream")
        }
        
        if recommendationsSection.contains(indexPath.section) {
            header.setup(label: "Similar")
        }
        
        return header
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedMediaSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaDetailCell", for: indexPath) as? MediaDetailCollectionViewCell else {return UICollectionViewCell()}
            guard let media = selectedMedia else {return UICollectionViewCell()}
            cell.setup(media: media)
            return cell
        }
        
        if whereToWatchSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "providerCell", for: indexPath) as? WhereToWatchCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(provider: providers[indexPath.row])
            return cell
        }
        
        if recommendationsSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendationCell", for: indexPath) as? RecommendationsCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(media: recommendations[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if recommendationsSection.contains(indexPath.section) {
            self.selectedMedia = recommendations[indexPath.row]
            setupViews()
//            self.collectionView.reloadData()
        }
    }
}//end extension
