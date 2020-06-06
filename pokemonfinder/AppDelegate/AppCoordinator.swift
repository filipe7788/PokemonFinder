import UIKit

protocol AppCoordinatorProcotol: CoordinatorProtocol {
    func back()
}

enum AppPath: CoordinatorPath {
    case start, name, selectFavorite, favorite(username: String), home(favoriteType: String)
}

class AppCoordinator: Coordinator, AppCoordinatorProcotol {

    var window: UIWindow
    public typealias ModelDependency = Void
    
    required init(window: UIWindow) {
        self.window = window
    }

    func start(as startType: StartType, with input: Void?) {
        let viewController = StartScreenViewController(viewModel: StartScreenViewModel(coordinator: self))
        show(viewController: viewController, as: startType)
    }
    
    func route(to path: CoordinatorPath) {
        guard let path = path as? AppPath else { return }
        switch path {
        case .name:
            let viewModel = SubscribeNameViewModel(coordinator: self)
            let viewController = SubscribeNameViewController(viewModel: viewModel)
            show(viewController: viewController, as: .root(withNavigationController: false))
        case .favorite(let name):
            let viewModel = ChooseFavoriteViewModel(coordinator: self, userName: name)
            let viewController = ChooseFavoriteViewController(viewModel: viewModel)
            show(viewController: viewController, as: .modal(animated: true))
        case .selectFavorite:
            let viewModel = SelectFavoriteViewModel(coordinator: self)
            let viewController = SelectFavoriteViewController(viewModel: viewModel)
            show(viewController: viewController, as: .modal(animated: true))
        case .home(let favoriteType):
            let viewModel = HomeViewModel(favoriteType: favoriteType)
            let viewController = HomeViewController(viewModel: viewModel)
            show(viewController: viewController, as: .root(withNavigationController: false))
        default:
            print("rota não criada ainda")
        }
    }
    
    func finish() {
    }
    
    func back() {
        dismiss()
    }
    
}
