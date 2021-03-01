

import Foundation

final class AppCoordinator: BaseCoordinator {
    
    override func start() {
        runLoginFlow()
    }
    
    // MARK: - Private
    
    private func runLoginFlow() {
        let coordinator = LoginCoordinator(router)
        coordinator.finishFlow = { [unowned self] in
            self.presentPosts()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func presentPosts() {
        let coordinator = PostsCoordinator(router)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.runLoginFlow()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
}
