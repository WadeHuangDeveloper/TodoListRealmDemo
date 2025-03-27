//
//  TaskEditViewController.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import UIKit
import Combine

class TaskEditViewController: UIViewController {
    let viewModel: TaskEditViewControllerViewModel
    private var cancelBarButtonItem = UIBarButtonItem()
    private var doneBarButtonItem = UIBarButtonItem()
    private var deleteBarButtonItem = UIBarButtonItem()
    private var statusButton = UIButton()
    private var titleTextField = UITextField()
    private var createTimestampLabel = UILabel()
    private var finishTimestampLabel = UILabel()
    private var stackView = UIStackView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TaskEditViewControllerViewModel) {
        self.viewModel = viewModel
        self.viewModel.editIsDone = viewModel.task.object.isDone
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
    }
    
    private func initUI() {
        cancelBarButtonItem.image = UIImageResource.cancel
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(onCancelBarButtonClick)
        
        doneBarButtonItem.image = UIImageResource.done
        doneBarButtonItem.target = self
        doneBarButtonItem.action = #selector(onUpdateButtonClick)
        
        deleteBarButtonItem.image = UIImageResource.delete
        deleteBarButtonItem.target = self
        deleteBarButtonItem.action = #selector(onDeleteButtonClick)
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItems = [deleteBarButtonItem, doneBarButtonItem]
        
        let image = viewModel.task.object.isDone == true ? UIImageResource.check : UIImageResource.uncheck
        statusButton.configuration = statusButton.getConfiguration(image: image)
        statusButton.addTarget(self, action: #selector(onStatusButtonClick), for: .touchUpInside)
        statusButton.imageView?.contentMode = .scaleAspectFit
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.text = viewModel.task.object.title
        titleTextField.font = UIFontResource.largeTitle
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        createTimestampLabel.text = "\(UITextResource.createAt) \(viewModel.task.object.createTimestamp.toDateTimeString())"
        createTimestampLabel.font = UIFontResource.title
        createTimestampLabel.textColor = UIColorResource.subtitle
        createTimestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let finishTimestampText = viewModel.task.object.finishTimestamp == nil ? "" : "\(UITextResource.finishAt) \(viewModel.task.object.finishTimestamp!.toDateTimeString())"
        finishTimestampLabel.text = finishTimestampText
        finishTimestampLabel.font = UIFontResource.title
        finishTimestampLabel.textColor = UIColorResource.subtitle
        finishTimestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(createTimestampLabel)
        stackView.addArrangedSubview(finishTimestampLabel)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        view.addGestureRecognizer(tapGesture)
        view.addSubview(statusButton)
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            statusButton.heightAnchor.constraint(equalToConstant: 60),
            statusButton.widthAnchor.constraint(equalToConstant: 60),
            statusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            statusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    @MainActor
    @objc private func onCancelBarButtonClick() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @MainActor
    @objc private func onStatusButtonClick() {
        view.endEditing(true)
        viewModel.editIsDone = !viewModel.editIsDone
        updateStatusButton(isDone: viewModel.editIsDone)
    }
    
    @MainActor
    @objc private func onUpdateButtonClick() {
        view.endEditing(true)
        guard let text = titleTextField.text, !text.isEmpty else {
            showError(message: UITextResource.emptyAlert)
            return
        }
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            viewModel.update(task: viewModel.task.object, title: text, isDone: viewModel.editIsDone)
        }
    }
    
    @MainActor
    @objc private func onDeleteButtonClick() {
        view.endEditing(true)
        showDeleteAlert(message: UITextResource.deleteAlert) { [weak self] in
            guard let self = self else { return }
            dismiss(animated: true) {
                self.viewModel.delete(task: self.viewModel.task.object)
            }
        }
    }
    
    @MainActor
    @objc private func onTapGesture() {
        view.endEditing(true)
    }
    
    @MainActor
    private func showError(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: UITextResource.okAction, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    @MainActor
    private func showDeleteAlert(message: String, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: UITextResource.deleteAction, style: .destructive) { _ in
            handler?()
        }
        let cancelAction = UIAlertAction(title: UITextResource.cancelAction, style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    private func setupCombine() {
        viewModel.$editIsDone
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                self.updateStatusButton(isDone: status)
            }
            .store(in: &cancellables)
    }
    
    private func updateStatusButton(isDone: Bool) {
        let image = isDone == true ? UIImageResource.check : UIImageResource.uncheck
        statusButton.configuration = statusButton.getConfiguration(image: image)
        statusButton.imageView?.contentMode = .scaleAspectFit
    }
}
