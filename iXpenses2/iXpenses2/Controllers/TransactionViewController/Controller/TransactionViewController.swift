//
//
//  TransactionViewController.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 24.03.2021.
//
//
import Reusable
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class TransactionViewController: UITableViewController, BindableType, NibBased {
//    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    // Bag
    public private(set) var disposeBag = DisposeBag()

    // Add here outlets

    // Add here your view model
    var viewModel: TransactionViewModel!

    // RxDataSources
    lazy var animConfig: AnimationConfiguration = {
        let config = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .automatic, deleteAnimation: .fade)
        return config
    }()

    lazy var configCell: (TableViewSectionedDataSource<TransactionSectionItem>, UITableView, IndexPath, TransactionRowItem) -> UITableViewCell = { _, tableView, indexPath, item in

        switch item {
        case .transaction(let transaction):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TransactionTableViewCell.self)
            cell.setup(with: transaction)
            return cell
        default:
            return UITableViewCell()
        }
    }

    lazy var animatedDataSource =
        RxTableViewSectionedAnimatedDataSource<TransactionSectionItem>(animationConfiguration: self.animConfig,
                                                                       configureCell: self.configCell)

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.delegate = nil
        animatedDataSource.canEditRowAtIndexPath = { _, _ in
            true
        }

        navigationItem.title = viewModel.project.name

        tableView.contentInset.top = 24
        tableView.register(cellType: TransactionTableViewCell.self)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        if !viewModel.project.transactions.isEmpty {
            tableView.contentInset.top = -20
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .middle, animated: false)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: BIND VIEW MODEL

    func bindViewModel() {
        viewModel.output.transactionSections.asObservable()
            .bind(to: tableView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)
    }
}

extension TransactionViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить") { [weak self] _, _, completionHandler in
            // YOUR_CODE_HERE
            guard let self = self else { return }
            guard let cell = tableView.cellForRow(at: indexPath) as? TransactionTableViewCell, let item = cell.transaction else { return }

            self.viewModel.project.removeTransaction(item)

            ProjectsRepository.defaultRepo.update(item: self.viewModel.project)

            completionHandler(true)
        }

        deleteAction.backgroundColor = .systemRed

        let actions = [deleteAction]

        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
