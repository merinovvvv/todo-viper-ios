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
    private var todo: [TaskListViewModel] = [
        TaskListViewModel(
            id: UUID(),
            title: "first task",
            description: "description of 1st task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "second task",
            description: "description of 2nd task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "third task",
            description: "description of 3rd task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "first task",
            description: "description of 1st task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "second task",
            description: "description of 2nd task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "third task",
            description: "description of 3rd task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "first task",
            description: "description of 1st task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "second task",
            description: "description of 2nd task",
            createdAt: "02/02/2022",
            isCompleted: false
        ),
        TaskListViewModel(
            id: UUID(),
            title: "third task",
            description: "description of 3rd task",
            createdAt: "02/02/2022",
            isCompleted: false
        )
    ]
    
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
        view.backgroundColor = UIColor(named: "Black")
        setupUI()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseIdentifier, for: indexPath) as? TaskListCell else {
            return UITableViewCell()
        }
        
        let viewModel = todo[indexPath.row]
        
        cell.configure(with: viewModel)
        return cell
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
       
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        view.addSubview(tasksLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(footerView)
        
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
    
    func configureViews() {
        countLabel.text = "\(todo.count) задач"
    }
}

// MARK: - TaskListViewInput
extension TaskListViewController: TaskListViewInput {
    func showTodos(_ todos: [TaskListViewModel]) {
        
    }
    
    func deleteTodo(at index: Int) {
        
    }
    
    func showError(_ message: String) {
        
    }
    
    func markAsDone(at index: Int) {
        
    }
}
