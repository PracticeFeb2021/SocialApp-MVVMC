

final class PostsCoordinator: BaseCoordinator {

    var finishFlow: (() -> Void)?
    
    override func start() {
        showPostListVC()
    }
    
    // MARK: - Private methods
    
    // example: post list
    private func showPostListVC() {
        let postListVC = PostListVC.instantiateFromNib()
        postListVC.viewModel = PostListViewModel(NetworkManager())
        postListVC.onPostSelected = { [unowned self] post in
            self.showPostVC(with: post)
        }
        postListVC.onLogout = { [unowned self] in
            self.finishFlow?()
        }
        self.router.setRootModule(postListVC)
    }
    
    // example: back
    private func showPostVC(with post: Post) {
        let postVC = PostVC.instantiateFromNib()
        postVC.viewModel = PostViewModel(post, NetworkManager())
        postVC.onBack = { [unowned self] in
            self.router.popModule()
        }
        postVC.onLogout = { [unowned self] in
            self.finishFlow?()
        }
        self.router.push(postVC, completion: nil)
    }

    
    //example: another coordinator
//    private func showProfile() {
//        let coordinator = self.coordinatorFactory.makeProfileCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, vcFactory: self.vcFactory)
//        coordinator.finishFlow = { [unowned self, unowned coordinator] in
//            self.removeDependency(coordinator)
//            self.router.popModule()
//        }
//        self.addDependency(coordinator)
//        coordinator.start()
//    }
}
