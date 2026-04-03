//
//  TaskListCell.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 2.04.26.
//

import UIKit

final class TaskListCell: UITableViewCell {
    static let reuseIdentifier = "TaskListCell"
    
    // MARK: - Properties
    
    var onToggleCompletion: (() -> Void)?
    
    // MARK: - UI Properties
    
    private lazy var completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "Stroke")
        button.addTarget(self, action: #selector(didTapCompletion), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "White")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "White")
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "White")?.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onToggleCompletion = nil
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func configure(with viewModel: TaskListViewModel) {
        createdDateLabel.text = viewModel.createdAt
        descriptionLabel.text = viewModel.description
        
        let title = NSMutableAttributedString(string: viewModel.title)
        if viewModel.isCompleted {
            title.addAttributes(
                [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor(named: "White")?.withAlphaComponent(0.5) ?? UIColor.lightGray
                ],
                range: NSRange(location: 0, length: title.length)
            )
            descriptionLabel.textColor = UIColor(named: "White")?.withAlphaComponent(0.5)
            completionButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            completionButton.tintColor = UIColor(named: "Yellow")
        } else {
            descriptionLabel.textColor = UIColor(named: "White")
            completionButton.setImage(UIImage(systemName: "circle"), for: .normal)
            completionButton.tintColor = UIColor(named: "Stroke")
        }
        
        titleLabel.attributedText = title
    }
}

// MARK: - Setup UI
private extension TaskListCell {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
    }
    
    func setupViewHierarchy() {
        contentView.addSubview(completionButton)
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(createdDateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            completionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            completionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completionButton.widthAnchor.constraint(equalToConstant: 24),
            completionButton.heightAnchor.constraint(equalToConstant: 24),
            
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStackView.leadingAnchor.constraint(equalTo: completionButton.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}

// MARK: - Selectors
private extension TaskListCell {
    @objc func didTapCompletion() {
        onToggleCompletion?()
    }
}
