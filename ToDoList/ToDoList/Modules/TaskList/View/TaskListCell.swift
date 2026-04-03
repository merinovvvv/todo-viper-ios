//
//  TaskListCell.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 2.04.26.
//

import UIKit

private enum Constants {
    static let cornerRadius: CGFloat = 12
    static let horizontalInset: CGFloat = 20
}

final class TaskListCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "TaskListCell"
    var onToggleCompletion: (() -> Void)?
    
    // MARK: - UI Properties
    
    private lazy var completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "Stroke")
        button.addTarget(self, action: #selector(didTapCompletion), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let selectionTintView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Gray")
        view.alpha = 0
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        setContextMenuSelected(false, animated: false)
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
    
    func setContextMenuSelected(_ isSelected: Bool, animated: Bool) {
        let updates = {
            self.selectionTintView.alpha = isSelected ? 1 : 0
        }
        
        if animated {
            UIView.animate(
                withDuration: 0.18,
                delay: 0,
                options: [.beginFromCurrentState, .curveEaseInOut],
                animations: updates
            )
        } else {
            updates()
        }
    }
    
    func makeContextMenuPreview() -> UITargetedPreview {
        layoutIfNeeded()
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(
            roundedRect: backgroundContainerView.bounds,
            cornerRadius: Constants.cornerRadius
        )
        
        return UITargetedPreview(view: backgroundContainerView, parameters: parameters)
    }
}

// MARK: - Setup UI
private extension TaskListCell {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
    }
    
    func setupViewHierarchy() {
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(selectionTintView)
        backgroundContainerView.addSubview(completionButton)
        backgroundContainerView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(createdDateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectionTintView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor),
            selectionTintView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor),
            selectionTintView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor),
            selectionTintView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor),
            
            completionButton.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 12),
            completionButton.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor),
            completionButton.widthAnchor.constraint(equalToConstant: 24),
            completionButton.heightAnchor.constraint(equalToConstant: 24),
            
            textStackView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 12),
            textStackView.leadingAnchor.constraint(equalTo: completionButton.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -20),
            textStackView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor, constant: -12),
        ])
    }
}

// MARK: - Selectors
private extension TaskListCell {
    @objc func didTapCompletion() {
        onToggleCompletion?()
    }
}
