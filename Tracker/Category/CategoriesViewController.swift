
import UIKit

final class CategoriesViewController: UIViewController {
    
    private var viewModel: CategoriesViewModel
    private var selectedCategoryIndex: Int?
    init(
        delegate: CategoriesViewModelDelegate?,
        selectedCategory: TrackerCategory?
    ) {
        viewModel = CategoriesViewModel(
            selectedCategory: selectedCategory,
            delegate: delegate
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emptyView: СategoriesEmptyView = {
        let view = СategoriesEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(addcategory), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.separatorColor = .ypGray
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        title = "Категория"
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.updateClosure = { [weak self] in
            print("Update closure called")
            guard let self else { return }
            self.tableView.reloadData()
            self.showEmptyView()
        }
        
    }
    
    @objc private func addcategory() {
        print(#function)
        let viewController = NewCategoryViewController()
        viewController.delegate = self
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true, completion: nil)
    }
    
    private func showEmptyView() {
        tableView.isHidden = viewModel.tableViewIsHidden
        emptyView.isHidden = !viewModel.tableViewIsHidden
    }
    
    private func layout() {
        [tableView, addCategoryButton, emptyView].forEach { view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24),
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -24)
        ])
    }
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.categories.count
        showEmptyView()
        return count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            assertionFailure("Error of casting to CustomTableViewCell for CategoriesViewController")
            return UITableViewCell()
        }
        
        let category = viewModel.categories[indexPath.row].title
        cell.configureCell(
            with: category
        )
        
        cell.backgroundColor = .backgroundDay1
        
        if indexPath.row == viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16.0
        
        if viewModel.categories.count == 1 {
            cell.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        } else {
            let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == 0 {
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == numberOfRows - 1 {
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.maskedCorners = []
            }
        }
        
        if indexPath.row == selectedCategoryIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}
// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCategoryIndex = indexPath.row
        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
            let categoryTitle = cell.getSelectedCategoryTitle()
            viewModel.selectCategory(with: categoryTitle)
            tableView.reloadData()
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

extension CategoriesViewController: NewCategoryViewControllerDelegate {
    func didCreateCategory(_ category: TrackerCategory) {
        viewModel.selectCategory(with: category.title)
        viewModel.selectedCategory(category)
        tableView.reloadData()
    }
}
