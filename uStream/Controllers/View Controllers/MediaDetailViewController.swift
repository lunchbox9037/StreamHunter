//
//  MediaDetailViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/22/21.
//

import UIKit
import SafariServices

protocol RefreshDelegate: AnyObject {
    func refresh()
}

class MediaDetailViewController: UIViewController, SFSafariViewControllerDelegate  {
    // MARK: - Properties
    var selectedMedia: Media? {
        didSet {
            collectionView.reloadSections([0])
            collectionView.scrollToItem(at: [0,0], at: .top, animated: false)
        }
    }
    
    let selectedMediaSection: [Int] = [0]
    let whereToWatchSection: [Int] = [1]
    let similarSection: [Int] = [2]
    
    var providers: [Provider] = []
    var providerLink: String?
    var similar: [Media] = []
    
    static weak var delegate: RefreshDelegate?
    
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
        collectionView.register(MediaDetailCollectionViewCell.self, forCellWithReuseIdentifier: "mediaDetailCell")
        collectionView.register(WhereToWatchCollectionViewCell.self, forCellWithReuseIdentifier: "providerCell")
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "similarCell")
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
                if self.providers.count != 0 {
                    return LayoutBuilder.buildWhereToWatchIconSection()
                } else {
                    return nil
                }
            case 2:
                if self.similar.count != 0 {
                    return LayoutBuilder.buildMediaHorizontalScrollLayout()
                } else {
                    return nil
                }
            default:
                return nil
            }
        }
    }//end func
    
    func fetchWhereToWatch() {
        guard let media = selectedMedia else {return}
        let mediaType = media.getMediaTypeFor(media)
        WhereToWatchController.fetchWhereToWatchBy(id: media.id ?? 603, mediaType: mediaType) { [weak self] (result) in
            switch result {
            case .success(let location):
                DispatchQueue.main.async {
                    self?.providers = location.streaming ?? []
                    self?.providerLink = location.deepLink
                    self?.collectionView.reloadSections([1])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
    
    func fetchSimilar() {
        guard let media = selectedMedia else {return}
        let mediaType = media.getMediaTypeFor(media)
        SimilarController.fetchSimilarFor(mediaType: mediaType, id: media.id ?? 603 ) { [weak self] (result) in
            switch result {
            case .success(let similar):
                DispatchQueue.main.async {
                    self?.similar = similar
                    self?.collectionView.reloadSections([2])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//end func
    
    func launchApp(provider: Provider) {
        guard let providerName = provider.providerName else {return}
        print(providerName)
        let url = AppLinks.getURLFor(providerName: providerName)
        if let appURL = URL(string: url) {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                    if AppLinks.supportedApps.contains(providerName) {
                        let appID = AppLinks.getIDfor(providerName: providerName)
                        self.presentAppNotInstalledAlert(appName: providerName, appID: appID)
                    } else {
                        self.presentAppNotSupportedAlert(appName: providerName)
                    }
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }//end func
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }//end func
}//end class

// MARK: - Extensions
extension MediaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
            header.setup(label: ((self.selectedMedia?.name ?? self.selectedMedia?.title) ?? "The Matrix") )
        }
        
        if whereToWatchSection.contains(indexPath.section) {
            header.setup(label: "Stream")
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaDetailCell", for: indexPath) as? MediaDetailCollectionViewCell else {return UICollectionViewCell()}
            guard let media = selectedMedia else {return UICollectionViewCell()}
            cell.addDelegate = self
            cell.setup(media: media)
            return cell
        }
        
        if whereToWatchSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "providerCell", for: indexPath) as? WhereToWatchCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(provider: providers[indexPath.row], newIndexPath: indexPath)
            return cell
        }
        
        if similarSection.contains(indexPath.section) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as? MediaCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(media: similar[indexPath.row], indexPath: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }//end func
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if whereToWatchSection.contains(indexPath.section) {
            self.launchApp(provider: providers[indexPath.row])
        }
        if similarSection.contains(indexPath.section) {
            self.selectedMedia = similar[indexPath.row]
            setupViews()
        }
    }//end func
}//end extension

extension MediaDetailViewController: AddToListButtonDelegate {
    func addToList() {
        Haptics.playSuccessNotification()
        guard let selectedMedia = self.selectedMedia else {return}
        ListMediaController.shared.addToList(media: selectedMedia)
        MediaDetailViewController.delegate?.refresh()
    }
}//end extension
