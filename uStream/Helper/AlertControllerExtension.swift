//
//  AlertControllerExtension.swift
//  uStream
//
//  Created by stanley phillips on 3/3/21.
//

import UIKit

extension UIViewController {
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Whoops!", message: "No watch options currently available for this title...", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
