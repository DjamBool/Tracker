
import UIKit

final class Colors {
    let viewBackgroundColor = UIColor.systemBackground 
    
    let viewColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return .systemGray5
        } else {
            return .backgroundDay1
        }
    }
    
    let textColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return .ypBlack
        } else {
            return .white
        }
    }
}
