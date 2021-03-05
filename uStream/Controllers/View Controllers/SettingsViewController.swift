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
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.requestLocation()
        } else {
            print("error")
        }
    }
    
    func promptRating() {
        //replace with my app url!!!
        if let url = URL(string: "itms-apps://apple.com/app/id1523772947") {
            UIApplication.shared.open(url)
        } else {
            print("error with app store URL")
        }
    }
    
    func launchShareSheet() {
        //replace url with my app url once launched!!!
        if let appURL = NSURL(string: "https://apps.apple.com/us/app/id1523772947") {
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
    
    // MARK: - Tableview Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            launchHomeApp()
            tableView.deselectRow(at: indexPath, animated: true)
        case [1,0]:
            getLocation()
            tableView.deselectRow(at: indexPath, animated: true)
        case [2,1]:
            launchShareSheet()
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
            print("got location!")
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                guard let currentLocPlacemark = placemarks?.first else { return }
                print(currentLocPlacemark.isoCountryCode ?? "No country code found")
                self.locationManager.stopUpdatingLocation()
//                LocationController.shared.updateLocation(countryCode: currentLocPlacemark.isoCountryCode ?? "US")
                print(Locale.current.regionCode ?? "US")
                self.presentLocationUpdatedAlert()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location")
    }
}
