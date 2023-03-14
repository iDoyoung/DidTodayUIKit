//
//  DidDetailsViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/11.
//

import UIKit
import Combine

final class DidDetailsViewController: UIViewController {
    
    var viewModel: DidDetailsViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private let didDetailView = DidDetailsView()
    
    //MARK: - Life Cycle
    static func create(with viewModel: DidDetailsViewModelProtocol) -> DidDetailsViewController {
        let viewController = DidDetailsViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func loadView() {
        view = didDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "trash")?.withConfiguration(imageConfiguration)
        let deleteItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(deleteDid))
        deleteItem.tintColor = .systemRed
        navigationItem.rightBarButtonItem = deleteItem
    }
    
    private func bindViewModel() {
        viewModel?.date
            .sink { date in
                self.didDetailView.dateLabel.text = date
            }
            .store(in: &cancellableBag)
        
        viewModel?.title
            .sink { title in
                self.didDetailView.titleLabel.text = title
            }
            .store(in: &cancellableBag)
        
        viewModel?.didTime
            .sink { didTime in
                self.didDetailView.didTimeLabel.text = didTime
            }
            .store(in: &cancellableBag)
        
        viewModel?.timeRange
            .sink { timeRange in
                self.didDetailView.timeRangeLabel.text = timeRange
            }
            .store(in: &cancellableBag)
        
        viewModel?.color
            .sink { color in
                self.didDetailView.color = color
            }
            .store(in: &cancellableBag)
    }
    
    @objc func deleteDid() {
        present(deleteAlert(), animated: true)
    }
}

extension DidDetailsViewController: DeleteDidAlert {
    
    func deleteHandler() {
        Task {
            try await viewModel?.delete()
            navigationController?.popViewController(animated: true)
        }
    }
}
