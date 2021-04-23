//
//  ProjectsViewController.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 21.03.2021.
//

import Closures
import Reusable
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class ProjectsViewController: UIViewController, BindableType, NibBased {
    var viewModel: ProjectsViewModel!

    public private(set) var disposeBag = DisposeBag()

    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

    var toolbarAppearance: UIToolbarAppearance?
    var seveBarAppearance: UIToolbarAppearance?

    var isFirstTime: Bool = true

//    @IBOutlet weak var tableView: UITableView!

    lazy var animConfig: AnimationConfiguration = {
        let config = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .automatic, deleteAnimation: .fade)
        return config
    }()

    lazy var configCell: (TableViewSectionedDataSource<SectionOfProjects>, UITableView, IndexPath, ProjectItem) -> UITableViewCell = { _, tableView, indexPath, item in

        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProjectItemCell.self)
        cell.setup(with: item)
        return cell
    }

    lazy var animatedDataSource =
        RxTableViewSectionedAnimatedDataSource<SectionOfProjects>(animationConfiguration: self.animConfig,
                                                                  configureCell: self.configCell)

    func bindViewModel() {
        viewModel.output.projectSections.bind(to: tableView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        addProjectButton.rx.tap
            .bind(to: viewModel.input.addProjectTrigger)
            .disposed(by: disposeBag)
    }

    lazy var moreBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle.fill")?.withTintColor(.systemBlue), style: .plain, handler: {})

    lazy var addTransBarButton: UIBarButtonItem = {
        let addTransactionButton = UIButton(type: .system)
        addTransactionButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)

        addTransactionButton.setTitle(" Транзакция", for: .normal)
        addTransactionButton.titleLabel?.font = UIFont(name: "SFProRounded-Semibold", size: 16)!
        return UIBarButtonItem(customView: addTransactionButton)
    }()

    lazy var addProjectButton = UIBarButtonItem(title: "Добавить проект", style: .plain, handler: {})

    override func viewDidLoad() {
        super.viewDidLoad()

        animatedDataSource.canEditRowAtIndexPath = { _, _ in
            true
        }

        navigationItem.title = "Проекты"

        navigationItem.rightBarButtonItem = moreBarButton
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.fillSuperview()

        tableView.register(cellType: ProjectItemCell.self)
        tableView.contentInset.top = 24
        tableView.contentInset.bottom = 24

        moreBarButton.tintColor = .systemBlue
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let nvc = navigationController {
            let toolbarApper = UIToolbarAppearance()
            toolbarApper.configureWithDefaultBackground()

            toolbarAppearance = toolbarApper
            let buttonAp = UIBarButtonItemAppearance(style: .plain)
            buttonAp.normal.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            toolbarApper.buttonAppearance = buttonAp

            nvc.toolbar.standardAppearance = toolbarApper

            nvc.navigationBar.prefersLargeTitles = true

            navigationItem.largeTitleDisplayMode = .automatic
            nvc.forceUpdateNavBar()

            addProjectButton.tintColor = .systemBlue
        }
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        DispatchQueue.main.async {
            self.navigationController?.toolbar.setItems([self.addTransBarButton, spacer, self.addProjectButton], animated: true)
        }

        if let toolbar = navigationController?.toolbar, isFirstTime, let toolbarApper = toolbarAppearance {
            isFirstTime = false

            let shadowColor = toolbarApper.shadowColor

            let toolBarHeightDriver: Driver<CGRect> = toolbar.rx.observe(\.bounds).asObservable()
                .asDriver(onErrorJustReturn: toolbar.bounds)

            let scrollViewTopContentInsetDriver: Driver<CGFloat> = BehaviorRelay<CGFloat>.init(value: tableView.contentInset.top).asDriver()

            let contentSizeDriver = tableView.rx.contentSize.asDriver()
            let boundsDriver = tableView.rx.observe(\.bounds).asDriver(onErrorJustReturn: tableView.bounds)

            let mainDriver = Driver.combineLatest(tableView.rx.contentOffset.asDriver(), contentSizeDriver, boundsDriver, toolBarHeightDriver, scrollViewTopContentInsetDriver)

            mainDriver.flatMapLatest { (contentOffset, contentSize, scrollViewBounds, toolBarHeight, scrollViewTopContentInset) -> Driver<UIBlurEffect?> in

                let visibleContentHeight: CGFloat = contentSize.height - contentOffset.y - scrollViewTopContentInset

                if visibleContentHeight >= (scrollViewBounds.height - toolBarHeight.height) {
                    return BehaviorRelay<UIBlurEffect?>.init(value: UIBlurEffect(style: .systemUltraThinMaterial)).asDriver()
                } else {
                    return BehaviorRelay<UIBlurEffect?>.init(value: nil).asDriver()
                }
            }.distinctUntilChanged()
                .withUnretained(self)
                .drive(onNext: { _, effect in
                    toolbar.standardAppearance.backgroundEffect = effect

                    if effect == nil {
                        toolbar.standardAppearance.shadowColor = nil
                    } else {
                        toolbar.standardAppearance.shadowColor = shadowColor
                    }

                }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

            navigationController?.setToolbarHidden(false, animated: false)

        } else {
            if let apper = seveBarAppearance {
                navigationController?.toolbar.standardAppearance = apper.copy()
            }
            navigationController?.setToolbarHidden(false, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        seveBarAppearance = navigationController?.toolbar.standardAppearance.copy()
    }
}

extension ProjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath) as? ProjectItemCell, let item = cell.projectItem {
            Observable<Void>.just(()).withLatestFrom(Observable<ProjectItem>.just(item))
                .bind(to: viewModel.input.projectDetailTrigger)
                .disposed(by: disposeBag)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить") { [weak self] _, _, completionHandler in
            // YOUR_CODE_HERE
            guard let cell = tableView.cellForRow(at: indexPath) as? ProjectItemCell, let item = cell.projectItem else { return }

            self?.showOkCancel(message: "Удалить проект \(item.name)?", okButtonTitle: "Продолжить", successHandler: {
                ProjectsRepository.defaultRepo.remove(item: item)
            })

            completionHandler(true)
        }

        deleteAction.backgroundColor = .systemRed

        let actions = [deleteAction]

        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
