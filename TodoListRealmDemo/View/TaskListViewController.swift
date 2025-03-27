//
//  TaskListViewController.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import UIKit
import Combine

class TaskListViewController: UIViewController {
    let viewModel: TaskListViewControllerViewModel
    private var createBarButtonItem = UIBarButtonItem()
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var loadingView = UIView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TaskListViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCombine()
        presentLoading()
        viewModel.readAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissLoading()
    }
    
    private func initUI() {
        createBarButtonItem.image = UIImageResource.create
        createBarButtonItem.target = self
        createBarButtonItem.action = #selector(onCreateBarButtonClick)
        
        navigationItem.rightBarButtonItem = createBarButtonItem
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.startAnimating()
        indicatorView.color = .lightGray
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(indicatorView)
        loadingView.backgroundColor = .darkGray
        loadingView.layer.cornerRadius = 5
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            indicatorView.heightAnchor.constraint(equalToConstant: 60),
            indicatorView.widthAnchor.constraint(equalToConstant: 60),
            indicatorView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            
            loadingView.heightAnchor.constraint(equalToConstant: 80),
            loadingView.widthAnchor.constraint(equalToConstant: 80),
            loadingView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),
            loadingView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    @MainActor
    private func presentLoading() {
        loadingView.isHidden = false
    }
    
    @MainActor
    private func dismissLoading() {
        loadingView.isHidden = true
    }
    
    @MainActor
    @objc private func onCreateBarButtonClick() {
        let viewModel = TaskCreateViewControllerViewModel(repository: viewModel.repository)
        setupEventCombine(viewModel: viewModel)
        let viewController = TaskCreateViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    @MainActor
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: UITextResource.okAction, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func setupCombine() {
        viewModel.$tasks
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.dismissLoading()
                    self.showAlert(message: error.localizedDescription)
                default:
                    break
                }
            } receiveValue: { [weak self] tasks in
                guard let self = self else { return }
                self.dismissLoading()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupEventCombine(viewModel: EventViewModel) {
        viewModel.event
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let failure) = completion {
                    switch failure {
                    case .readAll(let error), .create(let error), .update(let error), .delete(let error):
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            } receiveValue: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .create, .update, .delete:
                    self.viewModel.readAll()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        let task = viewModel.tasks[indexPath.section]
        let repository = viewModel.repository
        let viewModel = TaskTableViewCellViewModel(task: task, repository: repository)
        setupEventCombine(viewModel: viewModel)
        cell.configure(viewModel: viewModel)
        cell.selectionStyle = .none
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    @MainActor
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.section]
        let repository = viewModel.repository
        let viewModel = TaskEditViewControllerViewModel(task: task, repository: repository)
        setupEventCombine(viewModel: viewModel)
        let viewController = TaskEditViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
