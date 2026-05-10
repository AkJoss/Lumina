//
//  LuminaAppearance.swift
//  Lu
//

import UIKit

enum LuminaAppearance {
    static let background = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1)
    static let cardBackground = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
    static let primaryText = UIColor.white
    static let secondaryMuted = UIColor(white: 0.65, alpha: 1)
    static let accentGreen = UIColor(red: 0.38, green: 0.63, blue: 0.49, alpha: 1)

    static func applyDarkNavigationBar(_ navigationBar: UINavigationBar) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = background
        appearance.titleTextAttributes = [.foregroundColor: primaryText]
        appearance.largeTitleTextAttributes = [.foregroundColor: primaryText]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = primaryText
    }

    static func applyDarkTabBar(_ tabBar: UITabBar) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.tintColor = accentGreen
        tabBar.unselectedItemTintColor = secondaryMuted
    }
}
