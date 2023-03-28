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
        guard let viewModel else { return }
        viewModel.title
            .assign(to: \.text, on: didDetailView.titleLabel)
            .store(in: &cancellableBag)
        
        viewModel.didTime
            .assign(to: \.text, on: didDetailView.didTimeLabel)
            .store(in: &cancellableBag)
        
        viewModel.startedTime
            .zip(viewModel.finishedTime) { started, finished in
                "\(started ?? "") - \(finished ?? "")"
            }
            .assign(to: \.text, on: didDetailView.timeRangeLabel)
            .store(in: &cancellableBag)
        viewModel.color
            .assign(to: \.color, on: didDetailView)
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
