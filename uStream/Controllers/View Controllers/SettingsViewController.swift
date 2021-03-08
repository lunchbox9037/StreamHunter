//
//  SettingsViewController.swift
//  uStream
//
//  Created by stanley phillips on 3/3/21.
//

import UIKit
import SafariServices
import CoreLocation

class SettingsTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    // MARK: - Properties
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    let child = SpinnerViewController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func launchHomeApp() {
        if let url = URL(string: "com.apple.home://") {
            UIApplication.shared.open(url)
        } else {
            print("error with Home App URL")
        }
    }
    
    func getLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            createSpinnerView()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.requestLocation()
        } else {
            print("error")
        }
    }
    
    func promptRating() {
        //replace with my app url!!!
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        } else {
            print("error with app store URL")
        }
    }
    
    func launchShareSheet() {
        //replace url with my app url once launched!!!
        if let appURL = NSURL(string: "") {
            let objectsToShare: [Any] = [appURL]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = tableView
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func presentTMDBLink() {
        let urlString = "https://www.themoviedb.org"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    private func createSpinnerView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    private func stopSpinner() {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    // MARK: - Tableview Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            launchHomeApp()
            tableView.deselectRow(at: indexPath, animated: true)
        case [1,0]:
            getLocation()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2,0]:
            promptRating()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2,1]:
            launchShareSheet()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2,2]:
            presentAppInfoAlert()
            tableView.deselectRow(at: indexPath, animated: true)
        case [3,0]:
            presentTMDBLink()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
    }
}//end class

extension SettingsTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            self.locationManager.stopUpdatingLocation()
            geoCoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
                guard let currentLocPlacemark = placemarks?.first else {return}
                guard let countryCode = currentLocPlacemark.isoCountryCode else {return}
                UserDefaults.standard.setValue(countryCode, forKey: "countryCode")
                print("got location")
                self?.stopSpinner()
                self?.presentLocationUpdatedAlert(cc: countryCode)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location")
    }
}
