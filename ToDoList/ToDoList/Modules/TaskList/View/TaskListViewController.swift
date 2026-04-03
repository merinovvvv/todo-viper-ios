//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 2.04.26.
//

import UIKit

final class TaskListViewController: UIViewController,
                                    UISearchBarDelegate,
                                    UITableViewDelegate,
                                    UITableViewDataSource
{
    
    // MARK: - Dependencies
    
    private let presenter: TaskListViewOutput
    
    // MARK: - UI Properties
    
    private lazy var tasksLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.textColor = UIColor(named: "White")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "microphone.fill"), for: .bookmark, state: .normal)
        searchBar.tintColor = UIColor(named: "White")?.withAlphaComponent(0.5)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = UIColor(named: "Gray")
        textField.textColor = UIColor(named: "White")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor(named: "White")?.withAlphaComponent(0.5)
                ?? UIColor.lightGray
            ]
        )
        
        textField.leftView?.tintColor = UIColor(named: "White")?.withAlphaComponent(0.5)
        
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor(named: "Stroke")
        tableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Gray")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contextMenuOverlayView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        view.alpha = 0
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let colorOverlay = UIView()
        colorOverlay.backgroundColor = UIColor(named: "Black")?.withAlphaComponent(0.5)
        colorOverlay.translatesAutoresizingMaskIntoConstraints = false
        view.contentView.addSubview(colorOverlay)
        
        NSLayoutConstraint.activate([
            colorOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            colorOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "White")
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var newNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor(named: "Yellow")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Init
    
    init(presenter: TaskListViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Black")
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isMovingToParent {
            presenter.viewDidLoad()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseIdentifier, for: indexPath) as? TaskListCell else {
            return UITableViewCell()
        }
        
        guard let viewModel = presenter.viewModel(at: indexPath.row) else {
            return cell
        }
        
        cell.configure(with: viewModel)
        cell.onToggleCompletion = { [weak self] in
            self?.presenter.didTapChangeStatus(id: viewModel.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let viewModel = presenter.viewModel(at: indexPath.row) else {
            return
        }
        
        presenter.didTapTask(id: viewModel.id)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let viewModel = presenter.viewModel(at: indexPath.row) else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.presenter.didTapDelete(id: viewModel.id)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        guard let viewModel = presenter.viewModel(at: indexPath.row) else {
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
            guard let self else {
                return nil
            }
            
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil")
            ) { _ in
                self.presenter.didTapTask(id: viewModel.id)
            }
            
            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                self.presentShareSheet(for: viewModel)
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.presenter.didTapDelete(id: viewModel.id)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView,
                   previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        targetedPreview(for: configuration, in: tableView)
    }
    
    func tableView(_ tableView: UITableView,
                   previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        targetedPreview(for: configuration, in: tableView)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayContextMenu configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionAnimating?) {
        guard let indexPath = configuration.identifier as? NSIndexPath,
              let swiftIndexPath = indexPath as IndexPath?,
              let cell = tableView.cellForRow(at: swiftIndexPath) as? TaskListCell else {
            return
        }
        
        animator?.addAnimations {
            self.contextMenuOverlayView.alpha = 1
            cell.setContextMenuSelected(true, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionAnimating?) {
        guard let indexPath = configuration.identifier as? NSIndexPath,
              let swiftIndexPath = indexPath as IndexPath?,
              let cell = tableView.cellForRow(at: swiftIndexPath) as? TaskListCell else {
            return
        }
        
        animator?.addAnimations {
            self.contextMenuOverlayView.alpha = 0
            cell.setContextMenuSelected(false, animated: true)
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didSearch(query: searchText)
    }
    
    // TODO: - add micro
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didSearch(query: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        presenter.didSearch(query: "")
        searchBar.resignFirstResponder()
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        updateTaskCount()
        setupActions()
    }
    
    func setupViewHierarchy() {
        view.addSubview(tasksLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(footerView)
        view.addSubview(contextMenuOverlayView)
        
        footerView.addSubview(countLabel)
        footerView.addSubview(newNoteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tasksLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            tasksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tasksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchBar.topAnchor.constraint(equalTo: tasksLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            contextMenuOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            contextMenuOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contextMenuOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contextMenuOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -49),
            
            countLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            
            newNoteButton.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            newNoteButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20)
        ])
    }
    
    func updateTaskCount() {
        let count = presenter.numberOfRows()
        countLabel.text = "\(count) \(taskWord(for: count))"
    }
    
    func setupActions() {
        newNoteButton.addTarget(self, action: #selector(didTapAddTask), for: .touchUpInside)
    }
    
    func presentShareSheet(for viewModel: TaskListViewModel) {
        let shareText = """
        \(viewModel.title)
        
        \(viewModel.description)
        """
        
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(
                x: view.bounds.midX,
                y: view.bounds.midY,
                width: 0,
                height: 0
            )
        }
        
        present(activityViewController, animated: true)
    }
    
    func targetedPreview(for configuration: UIContextMenuConfiguration, in tableView: UITableView) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? NSIndexPath,
              let swiftIndexPath = indexPath as IndexPath?,
              let cell = tableView.cellForRow(at: swiftIndexPath) as? TaskListCell else {
            return nil
        }
        
        return cell.makeContextMenuPreview()
    }
    
    func taskWord(for count: Int) -> String {
        let remainder100 = count % 100
        let remainder10 = count % 10
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "задач"
        }
        
        switch remainder10 {
        case 1:
            return "задача"
        case 2, 3, 4:
            return "задачи"
        default:
            return "задач"
        }
    }
    
    @objc func didTapAddTask() {
        presenter.didTapAddTask()
    }
}

// MARK: - TaskListViewInput
extension TaskListViewController: TaskListViewInput {
    func reloadData() {
        updateTaskCount()
        tableView.reloadData()
    }
    
    func deleteTodo(at index: Int) {
        guard index >= 0 else {
            return
        }
        
        updateTaskCount()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func changeTaskStatus(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
