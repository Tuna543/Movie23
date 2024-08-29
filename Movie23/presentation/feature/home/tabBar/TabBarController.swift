//
//  TabBarController.swift
//  Movie23
//
//  Created by BS00880 on 3/7/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        
//        self.tabBar.barTintColor = .systemBackground
//        self.tabBar.tintColor = .systemBlue
//        self.tabBar.unselectedItemTintColor = .systemFill
        
    }
    

    private func setUpTabs() {
        let homeVC = self.createNav(with: LocalizedStringKey.home.localized() /*"Home"*/, and: UIImage(systemName: "house"), vc: HomeViewController())
        let watchListVC = self.createNav(with: LocalizedStringKey.watchList.localized()/*"WatchList"*/, and: UIImage(systemName: "list.bullet"), vc: WatchListViewController())
        let settingsVC = self.createNav(with: LocalizedStringKey.settings.localized() /*"Settings"*/, and: UIImage(systemName: "gearshape.fill"), vc: SettingsViewController())
        let searchVC = self.createNav(with: LocalizedStringKey.search.localized() /*"Search"*/, and: UIImage(systemName: "magnifyingglass"), vc: SearchViewController())
        self.setViewControllers([homeVC, searchVC, watchListVC, settingsVC], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
//        nav.viewControllers.first?.navigationItem.title = title
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        vc.navigationItem.leftBarButtonItem = leftItem
        
//        if title == "Search" {
//            let filterImageRight = UIImageView(image: UIImage(systemName: "slider.vertical.3"))
//            let rightItem = UIBarButtonItem(customView: filterImageRight)
//            vc.navigationItem.leftBarButtonItem = rightItem
//        }
        return nav
    }

}
