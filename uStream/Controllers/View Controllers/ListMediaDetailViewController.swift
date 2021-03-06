//
//  ListMediaDetailViewController.swift
//  uStream
//
//  Created by stanley phillips on 3/1/21.
//

import UIKit
import SafariServices

class ListMediaDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    // MARK: - Properties
    var selectedMedia: ListMedia? {
        didSet {
            collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    let selectedMediaSection: [Int] = [0]
    let whereToWatchSection: [Int] = [1]
    let similarSection: [Int] = [2]
    
    var providers: [Provider] = []
    var providerLink: String?
    var similar: [Media] = []
        
    // MARK: - Views
    lazy var dismissViewButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .systemGray2
        button.contentMode = .scaleAspectFill
        button.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.makeLayout())
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPrefetchingEnabled = true
        collectionView.prefetchDataSource = self
        collectionView.register(ListMediaDetailCollectionViewCell.self, forCellWithReuseIdentifier: "listMediaDetailCell")
        collectionView.register(WhereToWatchCollectionViewCell.self, forCellWithReuseIdentifier: "providerCell")
        collectionView.register(SimilarCollectionViewCell.self, forCellWithReuseIdentifier: "similarCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        setupViews()
    }
    
    // MARK: - Methods
    func setupViews() {
        fetchWhereToWatch()
        fetchSimilar()

        self.view.addSubview(self.dismissViewButton)
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.dismissViewButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            self.dismissViewButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.dismissViewButton.bottomAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }//end func
    
    func makeLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                return LayoutBuilder.buildMediaDetailSection()
            case 1:
                return LayoutBuilder.buildWhereToWatchIconSection()
            case 2:
                return LayoutBuilder.buildMediaHorizontalScrollLayout()
            default:
                return nil
            }
        }
    }//end func
    
    func fetchWhereToWatch() {
        guard let media = selectedMedia,
              let mediaType = media.mediaType else {return}
        WhereToWatchController.fetchWhereToWatchBy(id: Int(media.id), mediaType: mediaType) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let location):
                    self?.providers = location.streaming ?? []
                    self?.providerLink = location.deepLink
                    self?.collectionView.reloadSections(IndexSet(integer: 1))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
    
    func fetchSimilar() {
        guard let media = selectedMedia,
              let mediaType = media.mediaType else {return}
        SimilarController.fetchSimilarFor(mediaType: mediaType, id: Int(media.id)) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let similar):
                    self?.similar = similar
                    self?.collectionView.reloadSections(IndexSet(integer: 2))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }//end func
}//end class

// MARK: - Extensions
extension ListMediaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
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
        if similarSection.contains(section) {
            return similar.count
        }
        return 0
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SectionHeader else {return UICollectionReusableView()}
        if selectedMediaSection.contains(indexPath.section) {
            header.setup(label: ((self.selectedMedia?.title) ?? "The Matrix"))
        }
        
        if whereToWatchSection.contains(indexPath.section) {
            if providers.count == 0 {
                header.setup(label: "Streaming Providers Unavailable")
            } else {
                header.setup(label: "Stream")
            }
        }
        
        if similarSection.contains(indexPath.section) {
            header.setup(label: "Similar")
        }
        
        return header
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if similarSection.contains(indexPath.section) {
                MediaController.fetchPosterFor(media: similar[indexPath.row]) { (_) in }
            }
        }
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedMediaSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listMediaDetailCell", for: indexPath) as? ListMediaDetailCollectionViewCell else {return UICollectionViewCell()}
            guard let media = selectedMedia else {return UICollectionViewCell()}
            cell.delegate = self
            cell.setup(media: media)
            return cell
        }
        
        if whereToWatchSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "providerCell", for: indexPath) as? WhereToWatchCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(provider: providers[indexPath.row], newIndexPath: indexPath)
            return cell
        }
        
        if similarSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as? SimilarCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(media: similar[indexPath.row], newIndexPath: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if whereToWatchSection.contains(indexPath.section) {
            AppLinks.launchApp(provider: providers[indexPath.row])
        }
        
        if similarSection.contains(indexPath.section) {
            let detailVC = MediaDetailViewController()
            detailVC.selectedMedia = similar[indexPath.row]
            present(detailVC, animated: false)
        }
    }//end func
}//end extension

extension ListMediaDetailViewController: MoreWatchOptionsDelegate {
    func moreWatchOptions(_ sender: ListMediaDetailCollectionViewCell) {
        guard let media = selectedMedia else {return}
        if let urlString = providerLink {
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                present(vc, animated: true)
            }
        } else {
            if let date = media.releaseDate {
                if date > Date() {
                    presentNotificationAlert(media: media, sender: sender)
                } else {
                    presentErrorAlert()
                }
            }
        }
    }//end func
}//end extension
