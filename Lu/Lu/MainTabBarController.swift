//
//  MainTabBarController.swift
//  Lu
//

import UIKit

/// Tab bar principal: al arrancar la app se muestra primero la pestaña Home (índice 1).
final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 0 = Search, 1 = Home, 2 = Library
        selectedIndex = 1
    }
}
