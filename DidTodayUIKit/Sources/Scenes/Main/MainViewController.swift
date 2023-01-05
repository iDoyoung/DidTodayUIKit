//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit
import Combine

final class MainViewController: DidListCollectionViewController {
    
    var viewModel: (MainViewModelInput & MainViewModelOutput)?
    private var cancellableBag = Set<AnyCancellable>()
    
    //MARK: - UI Objects
    private lazy var startButton: NeumorphismButton = {
        let button = NeumorphismButton(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        button.addTarget(self, action: #selector(showDoing), for: .touchUpInside)
        return button
    }()
    
    private let informationLabel: BoardLabel = {
        let label = BoardLabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemGray
        label.texts = ["아래 버튼을 누르면 시간을 재기 시작해요", "터치하여 무슨 일이던 시작해보세요"]
        return label
    }()
    
    //MARK: - Life Cycle
    static func create(with viewModel: MainViewModelProtocol) -> MainViewController {
        let viewController = MainViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    ///Primary setup
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchDids()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        informationLabel.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        informationLabel.stopAnimation()
    }
    
    private func configure() {
        setupNavigationBar()
        ///Layout Herarchy: Collection View 부터 구성후 버튼을 추가해야한다.
        ///Collection View
        configureCollectionView()
        configureDataSource()
        
        view.addSubview(startButton)
        view.addSubview(informationLabel)
        setupConstraintLayout()
        ///Bind
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        /// - Title
        let dateOfToday = Date.todayDateToString()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = dateOfToday
        /// - Bar Items
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let logoImage = UIImage(named: "app.logo")
        let plusImage = UIImage(systemName: "plus", withConfiguration: imageConfiguration)
        let calendarImage = UIImage(systemName: "calendar", withConfiguration: imageConfiguration)
        
        ///Setup Left Item
        let logoItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(showAbout))
        navigationItem.leftBarButtonItem = logoItem
        
        ///Setup Right Items
        let addItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(showCreateDid))
        let calendarItem = UIBarButtonItem(image: calendarImage, style: .plain, target: self, action: #selector(showCalendar))
        navigationItem.rightBarButtonItems = [addItem, calendarItem]
        
        navigationController?.navigationBar.tintColor = .customGreen
    }
    
    //MARK: - Binding
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.totalPieDids
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applyTotalDidSnapshot([items])
            }
            .store(in: &cancellableBag)
        viewModel.didItemsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applyDidListSnapshot(items)
            }
            .store(in: &cancellableBag)
    }
    
    override func bindSortingSupplementaryWithViewModel(supplementary: SortingSupplementaryView) {
        self.viewModel?.isSelectedRecentlyButton
            .receive(on: DispatchQueue.main)
            .sink { supplementary.recentlyButton.isSelected  = $0 }
            .store(in: &self.cancellableBag)
        
        self.viewModel?.isSelectedMuchTimeButton
            .receive(on: DispatchQueue.main)
            .sink { supplementary.muchTimeButton.isSelected = $0 }
            .store(in: &self.cancellableBag)
    }
    
    //MARK: - Setup
    private func setupConstraintLayout() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: startButton.frame.height),
            startButton.widthAnchor.constraint(equalToConstant: startButton.frame.width),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            informationLabel.widthAnchor.constraint(equalToConstant: 300),
            informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -10)
        ])
    }
    
    //MARK: - Action Method
    @objc func showAbout() {
        viewModel?.showAbout()
    }
    
    @objc func showCalendar() {
        viewModel?.showCalendar()
    }
    
    @objc func showCreateDid() {
        viewModel?.showCreateDid()
    }
    
    @objc func showDoing() {
        viewModel?.showDoing()
    }
    
    @objc override func tapRecentlyButton(_ sender: UIButton) {
        super.tapRecentlyButton(sender)
        viewModel?.selectRecently()
    }
    
    @objc override func tapMuchTimeButton(_ sender: UIButton) {
        super.tapMuchTimeButton(sender)
        viewModel?.selectMuchTime()
    }
}

//MARK: - CollectionView Extentions
extension MainViewController {
    /// - Tag: Configure
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .customBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        informationLabel.alpha = 0
        startButton.isHidden = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            informationLabel.alpha = 1
            startButton.isHidden = false
        }
    }
}
