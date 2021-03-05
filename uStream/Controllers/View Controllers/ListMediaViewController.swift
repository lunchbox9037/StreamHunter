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
    
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    var refresher: UIRefreshControl = UIRefreshControl()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupGestures()
        setupRefresher()
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
        listCollectionView.addGestureRecognizer(tap)
        tap.isEnabled = false
    }//end func
    
    func setupRefresher() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh list...")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        listCollectionView.addSubview(refresher)
    }//end func
    
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
    }//end func
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return LayoutBuilder.buildMediaVerticalScrollLayout()
        }
    }//end func
    
    func selectSegmentIndex() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            //all
            dataSource = ListMediaController.shared.listMedia
        case 1:
            //movie
            dataSource = ListMediaController.shared.listMediaMovie
        case 2:
            //tv
            dataSource = ListMediaController.shared.listMediaTV
        default:
            break
        }
        listCollectionView.reloadData()
    }//end func
    
    @objc func loadData() {
        selectSegmentIndex()
        self.refresher.endRefreshing()
    }//end func
    
    @objc func doneDeleting(_ gesture: UITapGestureRecognizer) {
        Haptics.playRigidImpact()
        longPressedEnabled = false
        self.listCollectionView.reloadData()
        self.tap.isEnabled = false
    }//end func
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        self.tap.isEnabled = true
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = listCollectionView.indexPathForItem(at: gesture.location(in: listCollectionView)) else {
                return
            }
            longPressedEnabled = true
            Haptics.playSuccessNotification()
            listCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            listCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            listCollectionView.endInteractiveMovement()
            
            self.listCollectionView.reloadData()
        default:
            listCollectionView.cancelInteractiveMovement()
        }
    }//end func
    
    @objc func removeBtnClick(_ sender: UIButton) {
        Haptics.playSelectionChanged()
        let hitPoint = sender.convert(CGPoint.zero, to: self.listCollectionView)
        let hitIndex = self.listCollectionView.indexPathForItem(at: hitPoint)
        //remove the image and refresh the collection view
        let itemToDelete = dataSource[hitIndex!.row]
        ListMediaController.shared.delete(item: itemToDelete)
        ListMediaController.shared.fetchListMedia()
        selectSegmentIndex()
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
    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//            return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//            print("Start index :- \(sourceIndexPath.item)")
//            print("End index :- \(destinationIndexPath.item)")
//
//            let tmp = dataSource[sourceIndexPath.item]
//            dataSource[sourceIndexPath.item] = dataSource[destinationIndexPath.item]
//            dataSource[destinationIndexPath.item] = tmp
//            listCollectionView.reloadData()
////            CoreDataStack.saveContext()
//
//     }
}//end extension

extension ListMediaViewController: RefreshDelegate {
    func refresh() {
        print("reload")
        ListMediaController.shared.fetchListMedia()
        selectSegmentIndex()
    }    
}//end extension
