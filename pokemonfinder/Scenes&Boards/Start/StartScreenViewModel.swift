import Foundation
import RxSwift
import RxCocoa

protocol StartScreenViewModelInput {
    var start: PublishSubject<Void> { get }
}

protocol StartScreenViewModelProtocol: ViewModel {
    var inputs: StartScreenViewModelInput { get }
}

struct StartScreenViewModel: StartScreenViewModelInput, StartScreenViewModelProtocol {
    var inputs: StartScreenViewModelInput { return self }
    
    // MARK: StartScreen ViewModelInput
    let start = PublishSubject<Void>()
    
    private let coordinator: AppCoordinatorProcotol
    private var disposeBag = DisposeBag()
    
    // MARK: Init
    init(coordinator: AppCoordinatorProcotol) {
        self.coordinator = coordinator
        start.subscribe(onNext: { _ in
            coordinator.route(to: AppPath.name)
        }).disposed(by: disposeBag)
    }
}
