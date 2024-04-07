import UIKit

final class TabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let todayController = UINavigationController(rootViewController: TodayViewController())
        let emptyController = UIViewController()
        
        todayController.tabBarItem = UITabBarItem(
            title: "First",
            image: UIImage(systemName: "house"),
            selectedImage: nil
        )
    
        emptyController.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: nil,
            selectedImage: nil
        )
        
        self.viewControllers = [todayController, emptyController]
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
