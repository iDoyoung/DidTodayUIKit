import UIKit

final class TabBarController: UITabBarController {
    
    var dependency = SceneDIContainer()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let todayNaviagationController = UINavigationController()
        
        todayNaviagationController.tabBarItem = UITabBarItem(
            title: "First",
            image: UIImage(systemName: "house"),
            selectedImage: nil
        )
    
        self.viewControllers = [todayNaviagationController]
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .systemGray
        
        var todayCoordinator = MainFlowCoordinator(navigationController: todayNaviagationController,
                                              dependencies: dependency)
        
        todayCoordinator.start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
