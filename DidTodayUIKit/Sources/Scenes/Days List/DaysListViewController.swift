import UIKit
import SwiftUI
import os

final class DaysListViewController: ParentUIViewController {

    // UI
    private lazy var rootView: DaysListRootView = {
        DaysListRootView(items: getDaysListItem())
    }()
    
    private lazy var hostingController: UIHostingController<DaysListRootView>! = {
        UIHostingController(rootView: rootView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
    }
    
    var dids: [Did] = []
    
    private func getDaysListItem() -> [DaysListItem] {
        return dids.reduce(into: [DaysListItem]()) { partialResult, did in
            if let existing = partialResult.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: did.started) }) {
                partialResult[existing].dids.append(did)
            } else {
                partialResult.append(DaysListItem(
                    date: Calendar.current.startOfDay(for: did.started), dids: [did]))
            }
        }
    }
}
