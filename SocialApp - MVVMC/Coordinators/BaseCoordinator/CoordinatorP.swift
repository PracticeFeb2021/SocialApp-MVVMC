
import UIKit

enum DeepLinkOption {
    
}

protocol CoordinatorP: class {
    func start()
}

protocol PresentableP {
    func toPresent() -> UIViewController?
}

protocol BaseViewControllerP: NSObjectProtocol, PresentableP {}


extension UIViewController: PresentableP {
    func toPresent() -> UIViewController? {
        return self
    }
}
