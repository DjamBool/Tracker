
import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func filterSelected(filter: Filters)
}

class FiltersViewController: UIViewController {

    var selectedFilter: Filters?
    private lazy var filters: [Filters] = Filters.allCases
    weak var delegate: FiltersViewControllerDelegate?

    // MARK: - UI
    private lazy var navBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фильтры"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.register(FiltersTableViewCell.self, forCellReuseIdentifier: FiltersTableViewCell.identifier)
        tableView.layer.cornerRadius = 16
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = navBarLabel.text
        tableView.dataSource = self
        tableView.delegate = self
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .ypWhite
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersTableViewCell.identifier, for: indexPath) as? FiltersTableViewCell else { return UITableViewCell()
        }
        
        let filter = filters[indexPath.row]
        cell.setTitle(with: filter.rawValue)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.filterSelected(filter: filter)
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
