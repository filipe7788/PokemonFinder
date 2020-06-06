import Foundation
import RxSwift
import RxCocoa

protocol SubscribeNameViewModelInput {
    var userName: PublishSubject<String> { get }
    var nextAction: PublishSubject<Void> { get }
}

protocol SubscribeNameViewModelProtocol: ViewModel {
    var inputs: SubscribeNameViewModelInput { get }
}

struct SubscribeNameViewModel: SubscribeNameViewModelInput, SubscribeNameViewModelProtocol {
    var inputs: SubscribeNameViewModelInput { return self }
    
    // MARK: SubscribeName ViewModelInput
    let userName = PublishSubject<String>()
    let nextAction = PublishSubject<Void>()
    
    private let coordinator: AppCoordinatorProcotol
    private var disposeBag = DisposeBag()
    
    // MARK: Init
    init(coordinator: AppCoordinatorProcotol) {
        self.coordinator = coordinator
        
        nextAction.withLatestFrom(userName.asObservable()).subscribe(onNext: { name in
            if name != "" {
              coordinator.route(to: AppPath.favorite(username: name))
            }
        }).disposed(by: disposeBag)
    }
}
