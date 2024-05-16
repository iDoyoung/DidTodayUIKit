import UIKit
import SwiftUI
import os
import Combine

final class DaysListViewController: ParentUIViewController {

    var action = DaysListAction()
    private var cancellableBag = [AnyCancellable]()
    
    // UI
    private lazy var rootView: DaysListRootView = {
        DaysListRootView(items: getDaysListItem(),
                         action: action)
    }()
    
    private lazy var hostingController: UIHostingController<DaysListRootView>! = {
        UIHostingController(rootView: rootView)
    }()
    
    
    private func buildDetailAction() {
        action.$selectedDate
            .sink { [weak self] date in
                if let date {
                    let destination = DetailDayViewController()
                    self?.present(destination, animated: true)
                }
            }
            .store(in: &cancellableBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        
        buildDetailAction()
    }
    
    var fetchedDids = FetchedDids()
    
    private func getDaysListItem() -> [DaysListItem] {
        logger.debug("Fetched Dids: \(self.fetchedDids.items)")
        return fetchedDids.items.reduce(into: [DaysListItem]()) { partialResult, did in
            if let existing = partialResult.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: did.started) }) {
                partialResult[existing].dids.append(did)
            } else {
                partialResult.append(DaysListItem(
                    date: Calendar.current.startOfDay(for: did.started), dids: [did]))
            }
        }
    }
}
