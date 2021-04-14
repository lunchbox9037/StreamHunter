//
//  AlertControllerExtension.swift
//  uStream
//
//  Created by stanley phillips on 3/3/21.
//

import UIKit

extension UIViewController {
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Whoops!", message: "No stream options currently available for your region...", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func presentAppInfoAlert() {
        let alertController = UIAlertController(title: "Version \(UIApplication.appVersion ?? "1.0")", message: "All streaming service info is provided by JustWatch. All other info and images provided by The Movie DB.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func presentNotificationAlert(media: ListMedia, sender: ListMediaDetailCollectionViewCell) {
        let alertController = UIAlertController(title: "This title is unreleased!", message: "Set reminder for release date?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            NotificationScheduler.shared.scheduleNotifications(media: media)
            sender.disableButton()
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
    
    func presentAppNotInstalledAlert(appName: String, appID: String) {
        let alertController = UIAlertController(title: "\(appName) is not installed!", message: "Would you like to download it in the App Store?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            if let url = URL(string: "itms-apps://apple.com/app/\(appID)") {
                UIApplication.shared.open(url)
            }
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
    
    func presentAppNotSupportedAlert(appName: String) {
        let alertController = UIAlertController(title: "Sorry!", message: "Linking to \(appName) is not currently supported.\n Would you still like to download it in the App Store?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            if let url = URL(string: "itms-apps://apple.com/apps") {
                UIApplication.shared.open(url)
            }
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
    
    func presentLocationSelectedAlert(cc: String) {
        let alertController = UIAlertController(title: "Location Updated to \"\(cc)\"!", message: "Your streaming providers will now be based on your selected country.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func presentLocationUpdatedAlert(cc: String) {
        let alertController = UIAlertController(title: "Location Updated to \"\(cc)\"!", message: "Your streaming providers will now be based on your current country.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func presentLocationUpateFailedAlert() {
        let alertController = UIAlertController(title: "Failed to update location!", message: "Make sure location services are enabled in settings.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        let settingAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(URL(string: "App-prefs:LOCATION_SERVICES")!)
        }
        alertController.addAction(settingAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
   
    func presentLocationSelectionAlert(sender: SettingsTableViewController) {
        let alertController = UIAlertController(title: "Set new location?", message: "This will change your streaming provider results.", preferredStyle: .alert)
        let currentLocAction = UIAlertAction(title: "Use Current Location", style: .default) { (_) in
            print("use current location")
            sender.getLocation()
        }
        
        let chooseLocAction = UIAlertAction(title: "Choose Location", style: .default) { (_) in
            print("select location")
            sender.presentLocationSelectVC()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(currentLocAction)
        alertController.addAction(chooseLocAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
