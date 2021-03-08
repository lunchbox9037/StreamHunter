//
//  AlertControllerExtension.swift
//  uStream
//
//  Created by stanley phillips on 3/3/21.
//

import UIKit

extension UIViewController {
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Whoops!", message: "No watch options currently available for your region...", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(dismissAction)
        alertController.popoverPresentationController?.barButtonItem = editButtonItem
        
        present(alertController, animated: true)
    }
    
    func presentLocationUpdatedAlert(cc: String) {
        let alertController = UIAlertController(title: "Location Updated to \"\(cc)\"!", message: "Your streaming providers will now be based on your current region.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func presentAppInfoAlert() {
        let alertController = UIAlertController(title: "Version \(UIApplication.appVersion ?? "1.0")", message: "All streaming service info is provided by JustWatch. The release date info is provided by The Movie DB.", preferredStyle: .alert)
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
        let alertController = UIAlertController(title: "\(appName) isn't installed!", message: "Would you like to go to the App Store to download it?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            if appID == "error" {
                if let url = URL(string: "itms-apps://apple.com/apps") {
                    UIApplication.shared.open(url)
                }
            } else {
                if let url = URL(string: "itms-apps://apple.com/app/\(appID)") {
                    UIApplication.shared.open(url)
                }
            }
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
}
