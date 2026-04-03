//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Yaraslau Merynau on 1.04.26.
//

import UIKit

final class TaskDetailViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Dependencies
    
    private let presenter: TaskDetailViewOutput
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    
    // MARK: - UI Properties
    
    private lazy var backButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        config.title = "Назад"
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = UIColor(named: "Yellow")
        config.imagePadding = 6
        button.configuration = config
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.keyboardDismissMode = .interactive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextView, completionButton])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = UIColor(named: "White")
        view.font = .systemFont(ofSize: 34, weight: .bold)
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.isScrollEnabled = false
        view.autocapitalizationType = .sentences
        view.returnKeyType = .default
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(named: "Yellow")
        button.addTarget(self, action: #selector(didTapCompletion), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "White")?.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = UIColor(named: "Yellow")
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        return picker
    }()

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let descriptionTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = UIColor(named: "White")
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.isScrollEnabled = false
        view.autocapitalizationType = .sentences
        view.returnKeyType = .default
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleHeightConstraint: NSLayoutConstraint?
    private var descriptionHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    init(presenter: TaskDetailViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Black")
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTextViewHeights()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeights()
        scrollCaretIfNeeded(in: textView)
    }
}

// MARK: - Setup UI
private extension TaskDetailViewController {
    func setupUI() {
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.hidesBackButton = true
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        
        titleTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        completionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        completionButton.setContentHuggingPriority(.required, for: .horizontal)
        
        setupViewHierarchy()
        setupConstraints()
    }
    
    func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleStackView)
        contentView.addSubview(dateStackView)
        contentView.addSubview(descriptionTextView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            completionButton.widthAnchor.constraint(equalToConstant: 28),
            completionButton.heightAnchor.constraint(equalToConstant: 28),
            
            dateStackView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            dateStackView.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            dateStackView.trailingAnchor.constraint(lessThanOrEqualTo: titleStackView.trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        titleHeightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 41)
        titleHeightConstraint?.isActive = true
        
        descriptionHeightConstraint = descriptionTextView.heightAnchor.constraint(equalToConstant: 120)
        descriptionHeightConstraint?.isActive = true
    }
    
    func updateTextViewHeights() {
        let titleSize = titleTextView.sizeThatFits(
            CGSize(width: titleTextView.bounds.width, height: .greatestFiniteMagnitude)
        )
        let minTitleHeight = ceil(titleTextView.font?.lineHeight ?? 41)
        titleHeightConstraint?.constant = max(minTitleHeight, titleSize.height)

        let descriptionSize = descriptionTextView.sizeThatFits(
            CGSize(width: descriptionTextView.bounds.width, height: .greatestFiniteMagnitude)
        )
        descriptionHeightConstraint?.constant = max(160, descriptionSize.height)
        view.layoutIfNeeded()
    }
    
    func scrollCaretIfNeeded(in textView: UITextView) {
        guard let selectedRange = textView.selectedTextRange else {
            return
        }
        
        let caretRect = textView.caretRect(for: selectedRange.end)
        let caretRectInScrollView = textView.convert(caretRect.insetBy(dx: 0, dy: -24), to: scrollView)
        scrollView.scrollRectToVisible(caretRectInScrollView, animated: false)
    }
    
    func updateCompletionButton(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
        completionButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

// MARK: - Selectors
private extension TaskDetailViewController {
    
    @objc func didTapBack() {
        presenter.didTapBack(
            title: titleTextView.text,
            description: descriptionTextView.text,
            createdAt: datePicker.date
        )
    }
    
    @objc func didTapCompletion() {
        presenter.didTapToggleCompletion()
    }

    @objc func didChangeDate() {
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
}

// MARK: - TaskDetailViewInput
extension TaskDetailViewController: TaskDetailViewInput {
    func showTodo(_ viewModel: TaskDetailViewModel) {
        titleTextView.text = viewModel.title
        descriptionTextView.text = viewModel.description
        dateLabel.text = viewModel.createdAt
        if let date = dateFormatter.date(from: viewModel.createdAt) {
            datePicker.date = date
        }
        updateCompletionButton(isCompleted: viewModel.isCompleted)
        updateTextViewHeights()
    }
    
    func updateCompletion(isCompleted: Bool) {
        updateCompletionButton(isCompleted: isCompleted)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
