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
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    func presentLocationUpdatedAlert(cc: String) {
        let alertController = UIAlertController(title: "Location Updated to \(cc)!", message: "Your streaming providers will now be based on your current region.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
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
}
