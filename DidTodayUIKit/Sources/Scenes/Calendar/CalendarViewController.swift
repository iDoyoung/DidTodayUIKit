//
//  CalendarViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/22.
//

import UIKit
import Combine
import HorizonCalendar

final class CalendarViewController: ParentUIViewController {
    
    ///Section of lise of dids collection view
    private enum Section: Int, CaseIterable {
        case didsOfSelected
    }
    //MARK: - Properties
    
    //MARK: Components
    var viewModel: CalendarViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DidsOfDayItemViewModel>?
    
    //MARK: UI Properties
    var contentView = CalendarContainerView()
    
    //MARK: - Methods
    //MARK: Life Cycle
    static func create(with viewModel: CalendarViewModelProtocol) -> CalendarViewController {
        let viewController = CalendarViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func loadView() {
        contentView.showDetailButton.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        view = contentView
        configureDataSource(with: contentView.collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configure()
        //TODO: - FetchDids를 View Did Load에서 호출하지 않을 방법 고려
        // View Did Load에서 fetchDids를 호출하지 않을 경우 Calendar가 그려질 때 아직 Fetch 전이므로 날짜 범위의 시작부분이 현재 날짜로 지정된다.
        viewModel?.fetchDids()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Core Data가 변경이 있을 경우 다시 Fetch해서 뷰를 그려야하기 때문에 View Will Appear시 Fetchg해야만 한다.
        viewModel?.fetchDids()
    }
    
    //MARK: Configure & Setup
    private func configure() {
        setupView()
        setupNavigationBar()
        configureCalendarViewDaySelectionHandler()
        scrollToToday()
    }
    
    private func setupView() {
        view.borderColor = .clear
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .default)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: imageConfiguration)
        let rightBarButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = rightBarButton
    }
   
    //MARK: Binding
    ///Binding with View Model
    func bindViewModel() {
        let contentView = contentView
        guard let viewModel else { return }
        
        // Updating UI Of Calendar
        viewModel.dateOfDids
            .combineLatest(viewModel.selectedDate)
            .receive(on: DispatchQueue.main)
            .sink {
                let calendarContent = contentView.setupCalendarViewContents(selected: $1, fetched: $0)
                contentView.calendarView.setContent(calendarContent)
            }
            .store(in: &cancellableBag)
        
        // Updating UI Of Collection View
        viewModel.displayedItemsOfDidSelectedDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.contentView.showDetailButton.isEnabled = !items.isEmpty
                self?.setSnapshot(items)
            }
            .store(in: &cancellableBag)
    }
}

//MARK: Actions
extension CalendarViewController {
    
    @objc private func close() {
        dismiss(animated: true)
    }

    @objc private func showDetail() {
        viewModel?.showDetail()
    }
}

//MARK: - Configure Calendar View
extension CalendarViewController {
    
    private func configureCalendarViewDaySelectionHandler() {
        contentView.calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }
            self.viewModel?.selectedDay = day.components
        }
    }
    
    private func scrollToToday() {
        contentView.calendarView.scroll(toMonthContaining: Date(), scrollPosition: .lastFullyVisiblePosition, animated: false)
    }
}

//MARK: - Collection View
extension CalendarViewController {
     
    private func configureDataSource(with collectionView: UICollectionView) {
        let didTitleCellRegistration = createDidTitleCellRegistration()
//        let didsOfSelectedSupplementaryRegistration = createDidsOfSelectedSupplementaryRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, DidsOfDayItemViewModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(
                    using: didTitleCellRegistration,
                    for: indexPath,
                    item: itemIdentifier)
            })
        
//        dataSource?.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
//            collectionView.dequeueConfiguredReusableSupplementary(using: didsOfSelectedSupplementaryRegistration, for: indexPath)
//        }
    }
    
    //MARK: Create Registration
//    private func createDidsOfSelectedSupplementaryRegistration() -> UICollectionView.SupplementaryRegistration<DetailDidSupplementaryView> {
//        UICollectionView.SupplementaryRegistration(elementKind: CalendarContainerView.sectionHeaderElementKind) { [weak self] supplementaryView, elementKind, indexPath in
//            guard let self = self,
//                  let viewModel = self.viewModel else { return }
//            ///Binding with ViewModel
//            viewModel.descriptionOfSelectedDay
//                .assign(to: \.text, on: supplementaryView.descriptionCountLabel)
//                .store(in: &self.cancellableBag)
//        }
//    }
    
    private func createDidTitleCellRegistration() -> UICollectionView.CellRegistration<DidTitleCell, DidsOfDayItemViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.borderWidth = 2
            cell.borderColor = .separator
            cell.titleLabel.text = itemIdentifier.title
            cell.titleLabel.textColor = itemIdentifier.color.isDark() ? .white : .black
            cell.backgroundColor = itemIdentifier.color
        }
    }
   
    private func setSnapshot(_ items: [DidsOfDayItemViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DidsOfDayItemViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
