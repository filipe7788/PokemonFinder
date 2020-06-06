import UIKit

public protocol CoordinatorPath { }

public enum StartType {
    case modal(animated: Bool), root(withNavigationController: Bool)
}

public protocol CoordinatorProtocol: class {
    func route(to path: CoordinatorPath)
    func finish()
}

public protocol Coordinator: CoordinatorProtocol {
    associatedtype ModelDependency
    
    var window: UIWindow { get }
    
    init(window: UIWindow)
    
    func start(as startType: StartType, with input: ModelDependency?)
}

public extension Coordinator {
    
    var currentViewController: UIViewController? {
        guard let rootViewController = window.rootViewController else { return nil }
        return currentViewController(root: rootViewController)
    }
    
    private func controllerRoot(for viewController: UIViewController) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController,
            let top = navigationController.topViewController {
            return currentViewController(root: top)
        }
        
        return viewController
    }
    
    private func currentViewController(root: UIViewController) -> UIViewController? {
        guard let presented = root.presentedViewController else {
            return controllerRoot(for: root)
        }
        
        return controllerRoot(for: presented)
    }
    
}

public extension Coordinator {
    
    func present(_ viewController: UIViewController, animated: Bool = true) {
        currentViewController?.present(viewController, animated: animated, completion: nil)
    }
    
    private func root(_ viewController: UIViewController) {
        if let snapshot = (window.snapshotView(afterScreenUpdates: true)) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            if let statusBar = UIApplication.shared.statusBarView, !UIApplication.shared.isStatusBarHidden {
                statusBar.removeFromSuperview()
                window.addSubview(statusBar)
            }
            
            UIView.transition(with: snapshot, duration: 0.4, options: [], animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
    
    func dismiss(animated: Bool = true) {
        currentViewController?.dismiss(animated: animated, completion: nil)
    }
    
    func show(viewController: UIViewController, as startType: StartType) {
        switch startType {
        case .modal(let animated):
            viewController.modalPresentationStyle = .custom
            present(viewController, animated: animated)
        case .root(let withNavigation):
            if withNavigation {
                let navController = UINavigationController(rootViewController: viewController)
                navController.navigationBar.isHidden = true
                navController.navigationBar.barStyle = .blackOpaque
                root(navController)
            } else {
                root(viewController)
            }
        }
    }
}
