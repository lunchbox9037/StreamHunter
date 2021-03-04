//
//  SettingsViewController.swift
//  uStream
//
//  Created by stanley phillips on 3/3/21.
//

import UIKit
import SafariServices

class SettingsTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func presentAPILink() {
        let urlString = "https://www.themoviedb.org"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    // MARK: - Tableview Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [2,0]:
            presentAPILink()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
    }
}//end class
