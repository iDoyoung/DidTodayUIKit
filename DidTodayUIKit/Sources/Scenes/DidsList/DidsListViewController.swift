import UIKit
import SwiftUI

final class DidsListViewController: ParentUIViewController {

    //MARK: - Properties
    
    var fetchedDids = FetchedDids()
    var action = TodayAction()
    
    // UI
    private lazy var rootView: DidsListRootView = {
        DidsListRootView(dids: fetchedDids)
    }()
    
    private lazy var hostingController: UIHostingController<DidsListRootView>! = {
        UIHostingController(rootView: rootView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
    }
}
