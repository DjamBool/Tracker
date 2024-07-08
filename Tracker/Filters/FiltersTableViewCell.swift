
import UIKit

final class FiltersTableViewCell: UITableViewCell {
    
    private lazy var customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutViews() {
        contentView.backgroundColor = .ypGray.withAlphaComponent(0.3)
        contentView.addSubview(customLabel)
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setTitle(with title: String) {
        self.customLabel.text = title
    }
}
