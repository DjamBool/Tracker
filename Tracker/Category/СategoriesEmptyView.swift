
import UIKit

final class СategoriesEmptyView: UIView {
    
    private var starImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "starImage")
        return view
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = """
Привычки и события можно
    объединить по смыслу
"""
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [starImage, infoLabel].forEach { self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            
            infoLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            infoLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
