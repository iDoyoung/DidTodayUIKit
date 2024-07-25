import UIKit

final class TabBarController: UITabBarController {
   
    let didCoreDataStore = DidCoreDataStorage()
    let reminderStore = ReminderStore()
    
    var fetchDidUseCase: FetchDidUseCase {
        DefaultFetchDidUseCase(storage: didCoreDataStore)
    }
    
    var readReminderUseCase: ReadReminderUseCaseProtocol {
        ReadReminderUseCase(stroage: reminderStore)
    }
    
    var requestAccessOfReminderUseCase: RequestAccessOfReminderUseCaseProtocol {
        RequestAccessOfReminderUseCase(stroage: reminderStore)
    }
    
    var getRemindersAuthorizationStatusUseCase: GetRemindersAuthorizationStatusUseCaseProtocol {
        GetRemindersAuthorizationStatusUseCase(storage: reminderStore)
    }
    
    var fetchedDids = FetchedDids()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // Today
        let todayNavigationController = UINavigationController(rootViewController: buildTodayViewController())
        todayNavigationController.tabBarItem = UITabBarItem(
            title: "First",
            image: UIImage(systemName: "doc.text.image"),
            selectedImage: nil
        )
        
        // Calendar
        let calendarNavigationController = UINavigationController(rootViewController: buildCalendarViewController())
        calendarNavigationController.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "calendar"),
            selectedImage: nil
        )
        
        // Dids List
        let didsListNavigationController = UINavigationController(rootViewController: buildDidsListViewController())
        didsListNavigationController.tabBarItem = UITabBarItem(
            title: "First",
            image: UIImage(systemName: "doc.text.image"),
            selectedImage: nil
        )
        
        // Day List
        
        self.viewControllers = [todayNavigationController, didsListNavigationController, buildDaysListViewController()]
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .systemGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            fetchedDids.items = try await fetchDidUseCase.execute()
        }
    }
    
    func buildTodayViewController() -> TodayViewController {
        let todayViewController = TodayViewController()
        todayViewController.fetchedDids = fetchedDids
        
//        todayViewController.fetchDidsUseCase = fetchDidUseCase
        todayViewController.readRemindersUseCase = readReminderUseCase
        todayViewController.getRemindersAuthorizationStatusUseCase = getRemindersAuthorizationStatusUseCase
        todayViewController.requestAccessOfRemindersUseCase = requestAccessOfReminderUseCase
        
        return todayViewController
    }
    
    func buildCalendarViewController() -> CalendarViewController {
        let calendarViewController = CalendarViewController()
        return calendarViewController
    }
    
    func buildDidsListViewController() -> DidsListViewController {
        let didsListViewController = DidsListViewController()
        didsListViewController.fetchedDids = fetchedDids
        return didsListViewController
    }
    
    func buildDaysListViewController() -> DaysListViewController {
        let daysListViewController = DaysListViewController()
        daysListViewController.fetchedDids = fetchedDids
        return daysListViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
