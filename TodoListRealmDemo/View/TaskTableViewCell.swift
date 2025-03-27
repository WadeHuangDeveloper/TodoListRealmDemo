//
//  TaskTableViewCell.swift
//  TodoListRealmDemo
//
//  Created by Huei-Der Huang on 2025/3/26.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "\(TaskTableViewCell.self)"
    var viewModel: TaskTableViewCellViewModel?
    private var checkmarkButton = UIButton()
    private var titleLabel = UILabel()
    private var createTimestampLabel = UILabel()
    private var finishTimestampLabel = UILabel()
    private var stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        checkmarkButton.configuration = checkmarkButton.getConfiguration(image: nil)
        checkmarkButton.imageView?.contentMode = .scaleAspectFit
        checkmarkButton.addTarget(self, action: #selector(onCheckmarkButtonClick), for: .touchUpInside)
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = ""
        titleLabel.font = UIFontResource.title
        titleLabel.textColor = UIColorResource.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        createTimestampLabel.text = ""
        createTimestampLabel.font = UIFontResource.subtitle
        createTimestampLabel.textColor = UIColorResource.subtitle
        createTimestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        finishTimestampLabel.text = ""
        finishTimestampLabel.font = UIFontResource.subtitle
        finishTimestampLabel.textColor = UIColorResource.subtitle
        finishTimestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(createTimestampLabel)
        stackView.addArrangedSubview(finishTimestampLabel)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            checkmarkButton.heightAnchor.constraint(equalToConstant: 50),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 50),
            checkmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            createTimestampLabel.heightAnchor.constraint(equalToConstant: 10),
            finishTimestampLabel.heightAnchor.constraint(equalToConstant: 10),
            
            stackView.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc private func onCheckmarkButtonClick() {
        guard let viewModel = viewModel else { return }
        viewModel.update(task: viewModel.task.object, isDone: !viewModel.task.object.isDone)
    }
    
    private func updateUI(viewModel: TaskTableViewCellViewModel) {
        let image = viewModel.task.object.isDone == true ? UIImageResource.check : UIImageResource.uncheck
        checkmarkButton.configuration = checkmarkButton.getConfiguration(image: image)
        checkmarkButton.imageView?.contentMode = .scaleAspectFit
        
        titleLabel.text = viewModel.task.object.title
        
        let createText = "\(UITextResource.createAt) \(viewModel.task.object.createTimestamp.toDateTimeString())"
        let finishText = viewModel.task.object.finishTimestamp != nil ? "\(UITextResource.finishAt) \(viewModel.task.object.finishTimestamp!.toDateTimeString())" : ""
        createTimestampLabel.text = "\(createText)"
        finishTimestampLabel.text = "\(finishText)"
    }
    
    func configure(viewModel: TaskTableViewCellViewModel) {
        self.viewModel = viewModel
        updateUI(viewModel: viewModel)
    }
}
