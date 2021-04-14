//
//  TopBarViewController.swift
//  uStream
//
//  Created by stanley phillips on 2/26/21.
//

import UIKit

class TopBarViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func settingButtonTapped(_ sender: Any) {
        guard let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(identifier: "settings") as? SettingsTableViewController else {return}
        let nav = UINavigationController(rootViewController: settingsVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let searchVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: "search") as? SearchViewController else {return}
        searchVC.modalPresentationStyle = .overCurrentContext
        present(searchVC, animated: true, completion: nil)
    }
}
