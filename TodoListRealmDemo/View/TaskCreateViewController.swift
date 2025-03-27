//
//  TaskCreateViewController.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import UIKit

class TaskCreateViewController: UIViewController {
    let viewModel: TaskCreateViewControllerViewModel
    private var cancelBarButtonItem = UIBarButtonItem()
    private var doneBarButtonItem = UIBarButtonItem()
    private var titleLabel = UILabel()
    private var titleTextField = UITextField()
    private var stackView = UIStackView()
    
    init(viewModel: TaskCreateViewControllerViewModel) {
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
    
    private func initUI() {
        cancelBarButtonItem.image = UIImageResource.cancel
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(onCancelBarButtonClick)
        
        doneBarButtonItem.image = UIImageResource.done
        doneBarButtonItem.target = self
        doneBarButtonItem.action = #selector(onCreateBarButtonClick)
        
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        titleLabel.text = UITextResource.newTaskName
        titleLabel.font = UIFontResource.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.text = ""
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleTextField)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        view.addGestureRecognizer(tapGesture)
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleTextField.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 2),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
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
    @objc private func onCreateBarButtonClick() {
        view.endEditing(true)
        guard let text = titleTextField.text, !text.isEmpty else {
            showAlert(message: UITextResource.emptyAlert)
            return
        }
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            viewModel.create(title: text)
        }
    }
    
    @MainActor
    @objc private func onTapGesture() {
        view.endEditing(true)
    }
    
    @MainActor
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: UITextResource.okAction, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}
