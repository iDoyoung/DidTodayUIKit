//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit
import SwiftUI
import Combine
import os

final class TodayViewController: ParentUIViewController {
   
    // MARK: - Properties
    
    var fetchedReminders = FetchedReminders()
    var fetchedDids = FetchedDids()
    var action = TodayAction()
    
    private var cancellableBag = [AnyCancellable]()
    
    // UI
    private(set) lazy var rootView: TodayRootView = {
        TodayRootView(reminders: fetchedReminders,
                      dids: fetchedDids, 
                      action: action)
    }()
    
    private(set) lazy var hostingController: UIHostingController<TodayRootView>! = {
        UIHostingController(rootView: rootView)
    }()
    
    var getRemindersAuthorizationStatusUseCase: GetRemindersAuthorizationStatusUseCaseProtocol!
    var requestAccessOfRemindersUseCase: RequestAccessOfReminderUseCaseProtocol!
    var readRemindersUseCase: ReadReminderUseCaseProtocol!
    var fetchDidsUseCase: FetchDidUseCase!
   
    private func buildCreateAction() {
        action.$isTapCreate
            .sink { [weak self] in
                guard let self else { return }
                if $0 {
                    self.logger.debug("Tap Create Button")
                    let destination = CreateDidViewController()
                    destination.createDidUseCase = DefaultCreateDidUseCase(storage: DidCoreDataStorage())
                    destination.modalPresentationStyle = .fullScreen
                    self.present(destination, animated: true)
                }
            }
            .store(in: &cancellableBag)
    }
    
    private func buildDetailAction() {
        action.$selectedDid
            .sink { [weak self] did in
                guard let did else { return }
                let destination = DidDetailsViewController()
                destination.did = did
                self?.navigationController?.pushViewController(destination, animated: true)
            }
            .store(in: &cancellableBag)
    }
    
    // View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        buildCreateAction()
        buildDetailAction()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        Task {
            fetchedReminders.isAccessReminders = try await getRemindersAuthorizationStatusUseCase.execute()
            fetchedReminders.items = try await readRemindersUseCase.execute()
            fetchedDids.items = try await fetchDidsUseCase.execute()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
  
    private func setupNavigationBar() {
        let dateOfToday = Date().toString()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = dateOfToday
    }
    
}

extension TodayViewController {
    
    func requestRemindersAuthorizationStatus() async throws -> Bool {
        return try await getRemindersAuthorizationStatusUseCase.execute()
    }
    
    func requestAccessOfReminders() async throws -> Bool {
        do {
            try await requestAccessOfRemindersUseCase.execute()
            return true
        } catch {
            return false
        }
    }
    
    func requestReadReminder() async throws -> [Reminder] {
        return try await readRemindersUseCase.execute()
    }
    
    func requestReadDids() async throws -> [Did] {
        try await fetchDidsUseCase.execute()
    }
}
