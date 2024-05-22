
import UIKit

// MARK: - NewCategoryViewControllerDelegate

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didCreateCategory(_ category: TrackerCategory)
}


// MARK: - NewCategoryViewController

final class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    private lazy var viewForTextFieldPlacement: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypLightGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Введите название категории"
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.smartInsertDeleteType = .no
        return textField
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(NewCategoryViewController.self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavBar()
        setupView()
        setupConstraints()
        doneButton.isEnabled = false
        doneButton.backgroundColor = .ypGray
    }
        
    @objc private func doneButtonTapped() {
        if let text = textField.text, !text.isEmpty {
            let category = TrackerCategory(title: text, trackers: [])
            delegate?.didCreateCategory(category)
        }
        dismiss(animated: true)
    }
        
    private func setupNavBar() {
        navigationItem.title = "Новая категория"
    }
    
    private func setupView() {
        viewForTextFieldPlacement.addSubview(textField)
        [viewForTextFieldPlacement,
         doneButton
        ].forEach {
            view.addSubview($0)
        }
        textField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            viewForTextFieldPlacement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewForTextFieldPlacement.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            viewForTextFieldPlacement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewForTextFieldPlacement.heightAnchor.constraint(equalToConstant: 75),
            
            textField.leadingAnchor.constraint(equalTo: viewForTextFieldPlacement.leadingAnchor, constant: 16),
            textField.centerYAnchor.constraint(equalTo: viewForTextFieldPlacement.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: viewForTextFieldPlacement.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, !text.isEmpty {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .ypBlack
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .ypGray
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
