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
    var longPressedEnabled: Bool = false
    
    var tap: UITapGestureRecognizer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MediaDetailViewController.delegate = self
        ListMediaController.shared.fetchListMedia()
        selectSegmentIndex()
    }
    
    // MARK: - Actions
    @IBAction func segmentControlChanged(_ sender: Any) {
        selectSegmentIndex()
    }
    
    // MARK: - Methods
    func setupGestures() {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(doneDeleting(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        listCollectionView.addGestureRecognizer(longPressGesture)
        guard let tap = tap else {return}
        listCollectionView.addGestureRecognizer(tap)
        tap.isEnabled = false
    }
    
    @objc func doneDeleting(_ gesture: UITapGestureRecognizer) {
        Haptics.playRigidImpact()
        longPressedEnabled = false
        self.listCollectionView.reloadData()
        self.tap?.isEnabled = false
    }
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        self.tap?.isEnabled = true
        Haptics.playSuccessNotification()
        print("ran")
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = listCollectionView.indexPathForItem(at: gesture.location(in: listCollectionView)) else {
                return
            }
            listCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            listCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            listCollectionView.endInteractiveMovement()
            longPressedEnabled = true
            self.listCollectionView.reloadData()
        default:
            listCollectionView.cancelInteractiveMovement()
        }
    }
    
    @objc func removeBtnClick(_ sender: UIButton) {
        Haptics.playSelectionChanged()
        let hitPoint = sender.convert(CGPoint.zero, to: self.listCollectionView)
        let hitIndex = self.listCollectionView.indexPathForItem(at: hitPoint)
        //remove the image and refresh the collection view
        let itemToDelete = dataSource[hitIndex!.row]
        ListMediaController.shared.delete(item: itemToDelete)
        selectSegmentIndex()
    }
    
    func selectSegmentIndex() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            //all
            ListMediaController.shared.fetchListMedia()
            dataSource = ListMediaController.shared.listMedia
        case 1:
            //movie
            ListMediaController.shared.fetchListMedia()
            dataSource = ListMediaController.shared.listMediaMovie
        case 2:
            //tv
            ListMediaController.shared.fetchListMedia()
            dataSource = ListMediaController.shared.listMediaTV
        default:
            break
        }
        listCollectionView.reloadData()
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
        
        cell.removeBtn.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
        
        if longPressedEnabled {
            cell.startAnimate()
        } else {
            cell.stopAnimate()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = ListMediaDetailViewController()
        detailVC.selectedMedia = dataSource[indexPath.row]
        present(detailVC, animated: true, completion: nil)
    }
}//end extension

extension ListMediaViewController: RefreshDelegate {
    func refresh() {
        print("reload")
        selectSegmentIndex()
    }    
}
