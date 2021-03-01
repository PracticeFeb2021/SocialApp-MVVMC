

class BaseCoordinator: CoordinatorP {
    
    var childCoordinators = [CoordinatorP]()

    let router: RouterP
    
    init(_ router: RouterP) {
        self.router = router
    }
    
    func addDependency(_ coordinator: CoordinatorP) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: CoordinatorP?) {
        guard childCoordinators.isEmpty == false,
              let coordinator = coordinator else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func start() {}
}
