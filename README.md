### List of directory

    ├── DidTodayUIKit
    │   ├── Resources
    │   │   └── Assets.xcassets
    │   │       ├── AccentColor.colorset
    │   │       │   └── Contents.json
    │   │       ├── AppIcon.appiconset
    │   │       │   ├── Contents.json
    │   │       │   ├── Icon.png
    │   │       │   ├── icon_20pt.png
    │   │       │   ├── icon_20pt@2x 1.png
    │   │       │   ├── icon_20pt@2x.png
    │   │       │   ├── icon_20pt@3x.png
    │   │       │   ├── icon_29pt.png
    │   │       │   ├── icon_29pt@2x 1.png
    │   │       │   ├── icon_29pt@2x.png
    │   │       │   ├── icon_29pt@3x.png
    │   │       │   ├── icon_40pt.png
    │   │       │   ├── icon_40pt@2x 1.png
    │   │       │   ├── icon_40pt@2x.png
    │   │       │   ├── icon_40pt@3x.png
    │   │       │   ├── icon_60pt@2x.png
    │   │       │   ├── icon_60pt@3x.png
    │   │       │   ├── icon_76pt.png
    │   │       │   ├── icon_76pt@2x.png
    │   │       │   └── icon_83.5@2x.png
    │   │       ├── Contents.json
    │   │       ├── CustomBackColor.colorset
    │   │       │   └── Contents.json
    │   │       ├── app.logo.imageset
    │   │       │   ├── Combined Shape Copy.png
    │   │       │   ├── Combined Shape Copy@2x.png
    │   │       │   ├── Combined Shape Copy@3x.png
    │   │       │   └── Contents.json
    │   │       ├── custom.background.colorset
    │   │       │   └── Contents.json
    │   │       ├── custom.green.colorset
    │   │       │   └── Contents.json
    │   │       └── secondary.custom.background.colorset
    │   │           └── Contents.json
    │   ├── Sources
    │   │   ├── AuthorizationManager.swift
    │   │   ├── Entry
    │   │   │   ├── AppDelegate.swift
    │   │   │   ├── BetaVersionMigration.swift
    │   │   │   ├── Coordinator
    │   │   │   │   ├── AboutFlowCoordinator.swift
    │   │   │   │   ├── CalendarFlowCoordinator.swift
    │   │   │   │   ├── Coordinator.swift
    │   │   │   │   ├── DoingFlowCoordinator.swift
    │   │   │   │   └── MainFlowCoordinator.swift
    │   │   │   ├── SceneDIContainer.swift
    │   │   │   └── SceneDelegate.swift
    │   │   ├── Models
    │   │   │   ├── Did.swift
    │   │   │   ├── ManagedDidItem+CoreDataClass.swift
    │   │   │   ├── ManagedDidItem+CoreDataProperties.swift
    │   │   │   └── PreviousVersionModel.swift
    │   │   ├── Scenes
    │   │   │   ├── About
    │   │   │   │   ├── AboutRouter.swift
    │   │   │   │   ├── AboutViewController.swift
    │   │   │   │   ├── Cells
    │   │   │   │   │   └── AboutCell.swift
    │   │   │   │   └── ViewModel
    │   │   │   │       ├── AboutDid.swift
    │   │   │   │       └── AboutViewModel.swift
    │   │   │   ├── Calendar
    │   │   │   │   ├── Calendar
    │   │   │   │   │   ├── DayLabel.swift
    │   │   │   │   │   └── MonthLabel.swift
    │   │   │   │   ├── CalendarRouter.swift
    │   │   │   │   ├── CalendarViewController.swift
    │   │   │   │   ├── Cells and Supplementary Views
    │   │   │   │   │   ├── DetailDidSupplementaryView.swift
    │   │   │   │   │   └── DidTitleCell.swift
    │   │   │   │   └── ViewModel
    │   │   │   │       ├── CalendarViewModel.swift
    │   │   │   │       └── DidsOfDayItemViewModel.swift
    │   │   │   ├── CreateDid
    │   │   │   │   ├── Base.lproj
    │   │   │   │   │   └── CreateDid.storyboard
    │   │   │   │   ├── CreateDidAlert.swift
    │   │   │   │   ├── CreateDidViewController.swift
    │   │   │   │   ├── CreateDidViewModel.swift
    │   │   │   │   └── ko.lproj
    │   │   │   │       └── CreateDid.strings
    │   │   │   ├── Custom
    │   │   │   │   ├── BoardLabel.swift
    │   │   │   │   ├── NeumorphismButton.swift
    │   │   │   │   └── PieView.swift
    │   │   │   ├── Detail Day
    │   │   │   │   ├── DetailDayViewController.swift
    │   │   │   │   └── DetailDayViewModel.swift
    │   │   │   ├── Did List Collection
    │   │   │   │   ├── Cells and Supplementary Views
    │   │   │   │   │   ├── DidCell.swift
    │   │   │   │   │   ├── SortingSupplementaryView.swift
    │   │   │   │   │   └── TotalDidsCell.swift
    │   │   │   │   ├── DidItemsViewModel.swift
    │   │   │   │   ├── DidListCollectionViewController.swift
    │   │   │   │   └── TotalOfDidsViewModel.swift
    │   │   │   ├── Doing
    │   │   │   │   ├── Base.lproj
    │   │   │   │   │   └── Doing.storyboard
    │   │   │   │   ├── CircularLabel.swift
    │   │   │   │   ├── DayIsChangedNotification.swift
    │   │   │   │   ├── DoingRouter.swift
    │   │   │   │   ├── DoingViewController.swift
    │   │   │   │   ├── DoingViewModel.swift
    │   │   │   │   ├── TimerAlert.swift
    │   │   │   │   └── ko.lproj
    │   │   │   │       └── Doing.strings
    │   │   │   ├── Main
    │   │   │   │   ├── Base.lproj
    │   │   │   │   ├── MainAlert.swift
    │   │   │   │   ├── MainRouter.swift
    │   │   │   │   ├── MainViewController.swift
    │   │   │   │   ├── ViewModel
    │   │   │   │   │   └── MainViewModel.swift
    │   │   │   │   └── ko.lproj
    │   │   │   ├── ParentUIViewController.swift
    │   │   │   └── PrivacyPolicy
    │   │   │       ├── PrivacyPolicyViewController.swift
    │   │   │       └── PrivacyPolicyViewModel.swift
    │   │   ├── Services
    │   │   │   └── CoreData
    │   │   │       └── DidCoreDataStorage.swift
    │   │   ├── UserNotificationManager.swift
    │   │   └── Utils
    │   │       ├── Extensions
    │   │       │   ├── Date+Extensions
    │   │       │   │   ├── Date+DifferenceToString.swift
    │   │       │   │   ├── Date+GetHoursAndMinutes.swift
    │   │       │   │   ├── Date+OmittedTime.swift
    │   │       │   │   ├── Date+ToDouble.swift
    │   │       │   │   └── Date+ToString.swift
    │   │       │   ├── Double+ToStringOfTimer.swift
    │   │       │   ├── TimeInterval+Times.swift
    │   │       │   ├── UIColor+Extensions
    │   │       │   │   ├── UIColor+Custom.swift
    │   │       │   │   ├── UIColor+GetRGB.swift
    │   │       │   │   ├── UIColor+GradientEffect.swift
    │   │       │   │   └── UIColor+IsDark.swift
    │   │       │   └── UIView+Extensions
    │   │       │       ├── UIView+Animate To Hide.swift
    │   │       │       ├── UIView+Border.swift
    │   │       │       ├── UIView+Corner Radius.swift
    │   │       │       ├── UIView+Shadow Effect.swift
    │   │       │       └── UIView+animateToShake.swift
    │   │       ├── Localize.swift
    │   │       ├── Namespaces
    │   │       │   ├── CustomText.swift
    │   │       │   └── StoryboardName.swift
    │   │       └── StoryboardInstantiable.swift
    │   └── Supportings
    │       ├── Base.lproj
    │       │   └── LaunchScreen.storyboard
    │       ├── DataModel.xcdatamodeld
    │       │   └── DataModel.xcdatamodel
    │       │       └── contents
    │       ├── Info.plist
    │       ├── en.lproj
    │       │   └── Localizable.strings
    │       └── ko.lproj
    │           ├── LaunchScreen.strings
    │           └── Localizable.strings
    ├── DidTodayUIKit.xcodeproj
    │   ├── project.pbxproj
    │   ├── project.xcworkspace
    │   │   ├── contents.xcworkspacedata
    │   │   ├── xcshareddata
    │   │   │   ├── IDEWorkspaceChecks.plist
    │   │   │   └── swiftpm
    │   │   │       ├── Package.resolved
    │   │   │       └── configuration
    │   │   └── xcuserdata
    │   │       └── doyoung.xcuserdatad
    │   │           ├── IDEFindNavigatorScopes.plist
    │   │           └── UserInterfaceState.xcuserstate
    │   ├── xcshareddata
    │   │   └── xcschemes
    │   │       ├── DidTodayUIKit-he.xcscheme
    │   │       ├── DidTodayUIKit-ko.xcscheme
    │   │       └── DidTodayUIKit.xcscheme
    │   └── xcuserdata
    │       └── doyoung.xcuserdatad
    │           ├── xcdebugger
    │           │   └── Breakpoints_v2.xcbkptlist
    │           └── xcschemes
    │               └── xcschememanagement.plist
    ├── DidTodayUIKitTests
    │   ├── AboutViewModelTests.swift
    │   ├── BetaVersionMigrationTests.swift
    │   ├── CalendarViewModelTests.swift
    │   ├── CreateDid
    │   │   ├── CreateDidViewControllerTests.swift
    │   │   └── CreateDidViewModelTests.swift
    │   ├── DetailDay
    │   │   └── DetaiDaylViewModelTests.swift
    │   ├── DidCoreDataStorageTests.swift
    │   ├── Doing
    │   │   └── DoingViewModelTests.swift
    │   ├── Main
    │   │   ├── MainViewControllerTests.swift
    │   │   └── MainViewModelTests.swift
    │   └── Seeds.swift
    └── README.md
