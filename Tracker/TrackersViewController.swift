
import UIKit

class TrackersViewController: UIViewController {
   
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.textColor = UIColor(named: "YPBlack") ?? UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY"
        label.frame.size.width = 77
        label.frame.size.height = 34
        label.text = formatter.string(from: currentDate)
        //label.font = UIFont(name: "SF Pro", size: 17) - !!!!!!
        label.font = UIFont.systemFont(ofSize: 17)
        label.edgeInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        label.backgroundColor = UIColor.lightGray // !!!!!!!
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
   private var errorImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "errorStar")
        return view
    }()
    
    private var whatWillWeTrackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor(named: "Black [day]") ?? UIColor.black
        label.font = UIFont(name: "SF Pro", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAddTrackerButton()
        makeDateBarButtonItem()
        makeSearchField()
        layoutSubviews()
        navigationItem.title = titleLabel.text
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func makeAddTrackerButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addtapped))
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
    }
    
    private func makeDateBarButtonItem() {
        let dateButton = UIBarButtonItem(customView: dateLabel)
        navigationItem.rightBarButtonItem = dateButton
    }
    
    func makeSearchField() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Поиск"
        navigationItem.searchController = search
    }
    
    @objc private func addtapped() {
        print("addtapped")
    }
    
    private func layoutSubviews() {
        view.addSubview(errorImage)
        view.addSubview(whatWillWeTrackLabel)
        
        NSLayoutConstraint.activate([
            
            errorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImage.widthAnchor.constraint(equalToConstant: 80),
            errorImage.heightAnchor.constraint(equalToConstant: 80),
            
            whatWillWeTrackLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatWillWeTrackLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            whatWillWeTrackLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            whatWillWeTrackLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -340),
            whatWillWeTrackLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
            print(text)
    }
}
