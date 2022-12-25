//
//  InformationViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/22.
//

import UIKit

final class InformationViewController: UITableViewController {
    
    private enum Section: Int, CaseIterable {
        case about, link
    }
    
    var viewModel: InformationViewModelProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    //MARK: - Life Cycle
    static func create(with viewModel: InformationViewModelProtocol) -> InformationViewController {
        let viewController = InformationViewController(style: .insetGrouped)
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setupNavigationBar()
        setupView()
        createCellRegistration()
    }
    
    //MARK: - Setup
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        title = "About"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(back))
    }
    
    private func setupView() {
        view.backgroundColor = .secondaryCustomBackground
    }
    
    private func createCellRegistration() {
        tableView.register(AboutCell.self, forCellReuseIdentifier: AboutCell.reuseIdentifier)
    }
}

//MARK: - Table View
extension InformationViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel,
              let sectionKind = Section(rawValue: section) else { return 0 }
        switch sectionKind {
        case .about:
            return 1
        case .link:
            return viewModel.items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionKind = Section(rawValue: indexPath.section),
              let viewModel = viewModel else { return UITableViewCell() }
        
        switch sectionKind {
        case .about:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.reuseIdentifier, for: indexPath) as? AboutCell else { return UITableViewCell() }
            cell.update(to: viewModel.about)
            cell.backgroundColor = .customBackground
            return cell
        case .link:
            let cell = UITableViewCell()
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = viewModel.items[indexPath.row].title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundColor = .customBackground
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionKind = Section(rawValue: indexPath.section) else { return }
        if sectionKind == .link {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: Action
extension InformationViewController {
    
    @objc private func back() {
        dismiss(animated: true)
    }
}
