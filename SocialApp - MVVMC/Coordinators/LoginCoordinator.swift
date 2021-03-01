

import Foundation


final class LoginCoordinator: BaseCoordinator {
    
    var finishFlow: (() -> Void)?
    
    override func start() {
        self.showLoginVC()
    }
    
    // MARK: - Private
    
    private func showLoginVC() {
        let loginVC = LoginVC.instantiateFromNib()
        loginVC.viewModel = LoginViewModel(netService: NetworkManager())
        loginVC.onLogin = { [unowned self] in
            self.finishFlow?()
        }
        self.router.setRootModule(loginVC)
    }
}
