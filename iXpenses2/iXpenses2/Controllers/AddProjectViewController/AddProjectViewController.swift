//
//  AddProjectViewController.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 22.03.2021.
//

import Closures
import Reusable
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class AddProjectViewController: UIViewController, NibBased, BindableType {
    var viewModel: AddProjectsViewModel!
    
    public private(set) var disposeBag = DisposeBag()
      
    var mutableProjectItemRelay: BehaviorRelay<ProjectItem> = .init(value: ProjectItem.empty)
    var dismissRelay: PublishRelay<Void> = .init()
    
    lazy var doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, handler: {})
    lazy var cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, handler: {})
    
    private var canDismiss: Bool = true
    
    private var textFieldCell: BigTextFieldTableViewCell?

    @IBOutlet weak var tableView: UITableView!
    lazy var configCell: (TableViewSectionedDataSource<AddProjectSection>, UITableView, IndexPath, AddProjectSectionItem) -> UITableViewCell = { [weak self] _, tableView, indexPath, item in
        guard let self = self else { return UITableViewCell() }
        switch item {
        case .colorsSectionItem(let projectItem):

            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SelectColorTableViewCell.self)

            cell.setup(with: self.mutableProjectItemRelay.value)
            
            let colorDriver = cell.colorItemRelay.asDriver()
            cell.colorItemRelay.asDriver()
                .withUnretained(self)
                .drive(onNext: { owner, colorItem in
                    
                    let oldItem = owner.mutableProjectItemRelay.value
                    
                    let newItem = ProjectItem(name: oldItem.name, iconName: oldItem.iconName, colorName: colorItem.colorName, transactions: oldItem.transactions)
                    
                    owner.mutableProjectItemRelay.accept(newItem)
                }, onCompleted: nil, onDisposed: nil)
                .disposed(by: cell.disposeBag)
                
            return cell
        case .iconSectionItem(let projectItem):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProjectIconCell.self)

            cell.setup(with: self.mutableProjectItemRelay.value)
            
            self.mutableProjectItemRelay.asDriver()
                .distinctUntilChanged()
                .withUnretained(self)
                .drive(onNext: { _, item in
                    cell.colorItemRelay.accept(ColorItem(colorName: item.colorName))
                    cell.iconItemRelay.accept(IconItem(iconName: item.iconName))
                }, onCompleted: nil, onDisposed: nil)
                .disposed(by: cell.disposeBag)
            
            return cell
        case .iconsCollectionSectionItem(let projectItem):
      
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SelectIconTableViewCell.self)

            cell.setup(with: self.mutableProjectItemRelay.value)

            cell.iconItemRelay.asDriver()
                .withUnretained(self)
                .drive(onNext: { owner, iconItem in
                    
                    let oldItem = owner.mutableProjectItemRelay.value
                    
                    let newItem = ProjectItem(name: oldItem.name, iconName: iconItem.iconName, colorName: oldItem.colorName, transactions: oldItem.transactions)
                    
                    owner.mutableProjectItemRelay.accept(newItem)
                }, onCompleted: nil, onDisposed: nil)
                .disposed(by: cell.disposeBag)
            
            return cell
            
        case .textFieldSectionItem(let projectItem):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BigTextFieldTableViewCell.self)
            self.textFieldCell = cell
            cell.setup(with: self.mutableProjectItemRelay.value)
            
            cell.textField.rx.text.asDriver()
                .withUnretained(self)
                .drive(onNext: { owner, newName in
                    
                    let oldItem = owner.mutableProjectItemRelay.value
                    
                    let newItem = ProjectItem(name: newName ?? "", iconName: oldItem.iconName, colorName: oldItem.colorName, transactions: oldItem.transactions)
                    
                    owner.mutableProjectItemRelay.accept(newItem)
                }, onCompleted: nil, onDisposed: nil)
                .disposed(by: cell.disposeBag)
            
            self.mutableProjectItemRelay.asDriver()
                .flatMapLatest { item -> Driver<UIColor> in
                    BehaviorRelay<UIColor>.init(value: item.iconColor).asDriver()
                }.distinctUntilChanged()
                .drive(onNext: { color in
                    cell.textField.textColor = color
                }, onCompleted: nil, onDisposed: nil).disposed(by: cell.disposeBag)
            
            return cell
        }
    }

    lazy var animatedDataSource = RxTableViewSectionedReloadDataSource<AddProjectSection>.init(configureCell: self.configCell)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundsAddProject")!
        tableView.backgroundColor = .clear
        
        navigationItem.title = "Проект"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = doneBarButton
        
        tableView.contentInset.top = 24
        tableView.register(cellType: SelectColorTableViewCell.self)
        tableView.register(cellType: SelectIconTableViewCell.self)
        tableView.register(cellType: ProjectIconCell.self)
        tableView.register(cellType: BigTextFieldTableViewCell.self)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        doneBarButton.tintColor = .systemBlue
        cancelBarButton.tintColor = .systemBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textFieldCell?.textField.clearButtonMode = .whileEditing
        textFieldCell?.textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
        
        if let navBar = navigationController?.navigationBar {
            navBar.isTranslucent = true
        }
        
        navigationController?.presentationController?.delegate = self
        presentationController?.delegate = self
    }

    func bindViewModel() {
        if let item = viewModel.input.projectItem {
            mutableProjectItemRelay.accept(item)
        }
        
        viewModel.output.addProjectSections.bind(to: tableView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)
        
        cancelBarButton.rx.tap
            .asDriver()
            .withUnretained(self)
            .drive(onNext: { owner, _ in
                
                if !owner.canDismiss {
                    owner.alertForDismiss()
                } else {
                    owner.dismissRelay.accept(())
                }
                
            }).disposed(by: disposeBag)
        
        dismissRelay.bind(to: viewModel.input.cancelTrigger)
            .disposed(by: disposeBag)
        
        let initialProjectItemDriver: Driver<ProjectItem?> = BehaviorRelay<ProjectItem?>.init(value: viewModel.input.projectItem).asDriver()
        
        Driver.combineLatest(initialProjectItemDriver, mutableProjectItemRelay.asDriver())
            .flatMapLatest { old, rhs -> Driver<EqualItemsAndEmpty> in
                let lhs = old ?? ProjectItem.empty
                let isEqual = (lhs.name == rhs.name) && (lhs.colorName == rhs.colorName) && (lhs.iconName == rhs.iconName) && (lhs.iconColor == rhs.iconColor)
                let notEmptyName = (!isEqual && !rhs.name.isEmpty)
                let item = EqualItemsAndEmpty(isEqual: isEqual, nameIsNoEmpty: notEmptyName)
                return BehaviorRelay<EqualItemsAndEmpty>.init(value: item).asDriver()
            }.distinctUntilChanged()
            .withUnretained(self)
            .drive(onNext: { owner, item in
                owner.canDismiss = item.isEqual
                owner.doneBarButton.isEnabled = item.nameIsNoEmpty
            }).disposed(by: disposeBag)
        
        doneBarButton.rx.tap
            .withLatestFrom(mutableProjectItemRelay)
            .bind(to: viewModel.input.doneTrigger)
            .disposed(by: disposeBag)
    }
    
    private func alertForDismiss() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let done = UIAlertAction(title: "Отменить изменения", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismissRelay.accept(())
        })
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(done)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension AddProjectViewController: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if !canDismiss {
            alertForDismiss()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return canDismiss
    }
}

struct EqualItemsAndEmpty: Equatable {
    let isEqual: Bool
    let nameIsNoEmpty: Bool
}
