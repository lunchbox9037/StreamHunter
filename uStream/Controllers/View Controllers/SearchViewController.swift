//
//  SearchViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/26/21.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var searchResults = [Media]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        searchbar.becomeFirstResponder()
        setupCollectionView()
    }
    
    // MARK: - Methods
    func setupCollectionView() {
        collectionView.collectionViewLayout = makeLayout()
        collectionView.backgroundColor = UIColor.systemFill

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPrefetchingEnabled = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "resultsCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return LayoutBuilder.buildMediaVerticalScrollLayout()
        }
    }//end func
}//end class

// MARK: - Extensions
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultsCell", for: indexPath) as? MediaCollectionViewCell else {return UICollectionViewCell()}
        cell.setup(media: searchResults[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = MediaDetailViewController()
        detailVC.selectedMedia = searchResults[indexPath.row]
        present(detailVC, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        MediaService().fetch(.search(searchText)) { [weak self] (result: Result<MediaResults, NetError>) in
            switch result {
            case .success(let search):
                DispatchQueue.main.async {
                    let filteredResults = search.results.filter({ (result) -> Bool in
                        return result.posterPath != nil && result.backdropPath != nil
                    })
                    self?.searchResults = filteredResults
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.text = ""
        self.dismiss(animated: true, completion: nil)
    }
}//end extension
