

import UIKit


protocol RouterP: PresentableP {
    
    func present(_ module: PresentableP?)
    
    func presentFullScreen(_ module: PresentableP?)
    
    func push(_ module: PresentableP?, completion: (() -> Void)?)
    
    func popModule()
    
    func dismissModule(completion: (() -> Void)?)
    
    func setRootModule(_ module: PresentableP?)
    
    func popToRootModule()
}


final class Router: NSObject, RouterP {
    
    private weak var rootController: UINavigationController?
    private var completions = [UIViewController : () -> ()]()
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init()
    }
    
    // MARK: - PresentableP
    
    func toPresent() -> UIViewController? {
        return self.rootController
    }
    
    // MARK: - RouterP
    
    func present(_ module: PresentableP?) {
        present(module, fullScreen: false)
    }
    func presentFullScreen(_ module: PresentableP?) {
        present(module, fullScreen: true)
    }
    
    private func present(_ module: PresentableP?,
                         fullScreen: Bool = false) {
        guard let controller = module?.toPresent() else { return }
        if fullScreen {
            controller.modalPresentationStyle = .fullScreen
        }
        self.rootController?.present(controller, animated: true, completion: nil)
    }
    
    func push(_ module: PresentableP?, completion: (() -> Void)? = nil) {
        
        guard let controller = module?.toPresent()
        else {  return }
        
        if let completion = completion {
            self.completions[controller] = completion
        }
        self.rootController?.pushViewController(controller, animated: true)
    }
    
    func popModule() {
        if let controller = rootController?.popViewController(animated: true) {
            self.runCompletion(for: controller)
        }
    }
    
    func popToModule(module: PresentableP?) {
        guard let controllers = self.rootController?.viewControllers,
              let module = module else {
            return
        }
        for controller in controllers {
            if controller == module as! UIViewController {
                self.rootController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func dismissModule(completion: (() -> Void)? = nil) {
        self.rootController?.dismiss(animated: true, completion: completion)
    }
    
    func setRootModule(_ module: PresentableP?) {
        guard let controller = module?.toPresent() else { return }
        self.rootController?.setViewControllers([controller], animated: false)
    }
    
    func popToRootModule() {
        if let controllers = rootController?.popToRootViewController(animated: true) {
            controllers.forEach { controller in
                self.runCompletion(for: controller)
            }
        }
    }
    
    // MARK: - Private 
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = self.completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}


