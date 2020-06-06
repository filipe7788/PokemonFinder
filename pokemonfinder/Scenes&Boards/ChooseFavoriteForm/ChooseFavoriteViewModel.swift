import Foundation
import RxSwift
import RxCocoa

protocol ChooseFavoriteViewModelInput {
    var touchTextField: PublishSubject<Void> { get }
    var backAction: PublishSubject<Void> { get }
    var nextAction: PublishSubject<Void> { get }
}

protocol ChooseFavoriteViewModelOutput {
    var userName: Driver<String> { get }
    var favoriteTypeName: Driver<String> { get }
}

protocol ChooseFavoriteViewModelProtocol: ViewModel {
    var inputs: ChooseFavoriteViewModelInput { get }
    var outputs: ChooseFavoriteViewModelOutput { get }
}

struct ChooseFavoriteViewModel: ChooseFavoriteViewModelInput, ChooseFavoriteViewModelProtocol {
   
    var inputs: ChooseFavoriteViewModelInput { return self }
    var outputs: ChooseFavoriteViewModelOutput { return self }
    
    // MARK: ChooseFavorite ViewModelInput
    let touchTextField = PublishSubject<Void>()
    let backAction = PublishSubject<Void>()
    let nextAction = PublishSubject<Void>()

    // MARK: Variables
    private var user = ""
    private let favoriteType = PublishSubject<String>()
    
    private let coordinator: AppCoordinatorProcotol
    private var disposeBag = DisposeBag()
    
    // MARK: Init
    init(coordinator: AppCoordinatorProcotol, userName: String) {
        self.coordinator = coordinator
        self.user = userName
        
        nextAction.withLatestFrom(favoriteType).subscribe(onNext: { favorite in
            if favorite != "" {
                coordinator.route(to: AppPath.home(favoriteType: favorite))
            }
        }).disposed(by: disposeBag)
        
        touchTextField.subscribe(onNext: { _ in
            coordinator.route(to: AppPath.selectFavorite)
        }).disposed(by: disposeBag)
        
        backAction.subscribe(onNext: { _ in
            coordinator.back()
        }).disposed(by: disposeBag)
        
        GlobalVariables.shared.favoriteType.bind(to: favoriteType).disposed(by: disposeBag)
    }
}

// MARK: ChooseFavorite ViewModelOutput
extension ChooseFavoriteViewModel: ChooseFavoriteViewModelOutput {
    var favoriteTypeName: Driver<String> {
        return favoriteType.asDriver(onErrorJustReturn: "")
    }
    
    var userName: Driver<String> {
        return Observable.just(self.user).asDriver(onErrorJustReturn: "")
    }
    
}
