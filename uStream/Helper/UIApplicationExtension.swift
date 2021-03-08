//
//  UIApplicationExtension.swift
//  uStream
//
//  Created by stanley phillips on 3/7/21.
//

import UIKit

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
