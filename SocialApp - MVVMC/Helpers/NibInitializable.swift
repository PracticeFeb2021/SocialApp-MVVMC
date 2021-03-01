
import UIKit


protocol NibInitializable {
    static var nibIdentifier: String { get }
}

extension NibInitializable {
    static var nib: UINib {
        return UINib(nibName: nibIdentifier, bundle: nil)
    }
}

extension UIView: NibInitializable {
    static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: NibInitializable {
    static var nibIdentifier: String {
        return String(describing: self)
    }
}

extension NibInitializable where Self: UIViewController {

    static func instantiateFromNib() -> Self {
        return Self(nibName: nibIdentifier, bundle: nil)
    }
}

extension NibInitializable where Self: UIView {

    static func instantiateFromNib() -> Self {
        guard let view = UINib(nibName: nibIdentifier, bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Couldn't find nib file for \(String(describing: Self.self))")
        }
        return view
    }

}
