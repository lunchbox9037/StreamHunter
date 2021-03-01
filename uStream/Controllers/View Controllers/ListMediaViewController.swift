//
//  ListMediaViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/28/21.
//

import UIKit

class ListMediaViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // MARK: - Properties
    var dataSource: [ListMedia] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ListMediaController.shared.fetchListMedia()
        dataSource = ListMediaController.shared.listMedia
        listCollectionView.reloadData()
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        selectSegmentIndex()
    }
    
    // MARK: - Methods
    func selectSegmentIndex() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            ListMediaController.shared.fetchListMedia()
            dataSource = ListMediaController.shared.listMedia
            listCollectionView.reloadData()
        case 1:
            ListMediaController.shared.fetchListMedia()
            dataSource = ListMediaController.shared.listMediaMovie
            listCollectionView.reloadData()
        case 2:
            ListMediaController.shared.fetchListMedia()
            dataSource = ListMediaController.shared.listMediaTV
            listCollectionView.reloadData()
        default:
            break
        }
    }
    
    func setupCollectionView() {
        listCollectionView.collectionViewLayout = makeLayout()
        listCollectionView.backgroundColor = UIColor.systemFill

        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.isPrefetchingEnabled = true

//        listCollectionView.prefetchDataSource = self
        listCollectionView.register(ListMediaCollectionViewCell.self, forCellWithReuseIdentifier: "listCell")
       
        listCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return LayoutBuilder.buildMediaVerticalScrollLayout()
        }
    }//end func
    
    
}//end class

extension ListMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListMediaCollectionViewCell else {return UICollectionViewCell()}
        cell.setup(media: dataSource[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailVC = MediaDetailViewController()
//        detailVC.selectedMedia = dataSource[indexPath.row]
//        present(detailVC, animated: true, completion: nil)
//    }
}
