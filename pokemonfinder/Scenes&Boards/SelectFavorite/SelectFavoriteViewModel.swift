import Foundation
import RxSwift
import RxCocoa

protocol SelectFavoriteViewModelInput {
    var didLoad: PublishSubject<Void> { get }
    var reload: PublishSubject<Void> { get }
    var backAction: PublishSubject<Void> { get }
}

protocol SelectFavoriteViewModelOutput {
    var types: Driver<[SectionViewModelType<TypeTableCellViewModel>]> { get }
    var loading: Driver<ViewState> { get }
    var favorite: Driver<String> { get }
}

protocol SelectFavoriteViewModelProtocol: ViewModel {
    var inputs: SelectFavoriteViewModelInput { get }
    var outputs: SelectFavoriteViewModelOutput { get }
}

struct SelectFavoriteViewModel: SelectFavoriteViewModelInput, SelectFavoriteViewModelProtocol {
    var inputs: SelectFavoriteViewModelInput { return self }
    var outputs: SelectFavoriteViewModelOutput { return self }
    
    // MARK: SelectFavorite ViewModelInput
    let didLoad = PublishSubject<Void>()
    var reload = PublishSubject<Void>()
    let backAction = PublishSubject<Void>()
    let favoriteType = PublishSubject<String>()

    // MARK: Variables
    private var typesItemsBehaviorRelay = BehaviorRelay<[SectionViewModelType<TypeTableCellViewModel>]>(value: [])
    private var typesObservableResult: Observable<Result<[Type]>>
    
    private var activityIndicator: ActivityIndicator
    private let coordinator: AppCoordinatorProcotol
    private var disposeBag = DisposeBag()
    
    // MARK: Init
    init(coordinator: AppCoordinatorProcotol) {
        self.coordinator = coordinator
        let indicator = ActivityIndicator()
        self.activityIndicator = indicator
        
        // Simulate loading behavior
        typesObservableResult = Observable.merge(didLoad, reload).flatMap({ _ in
            return API.rx.getTypes().delay(.seconds(3), scheduler: MainScheduler.instance).trackActivity(indicator)
        }).share()
        
        typesObservableResult.map { $0.failure }
            .unwrap().map { ($0, nil) }
            .bind(to: ApiErrorHandler.sharedInstance.rx.handleError)
            .disposed(by: disposeBag)
        
        typesObservableResult
            .map { $0.value }
            .unwrap()
            .map({ itens in
            return [SectionViewModelType<TypeTableCellViewModel>(viewModels: itens.map {
                TypeTableCellViewModel(type: $0)})]
            })
            .bind(to: typesItemsBehaviorRelay)
            .disposed(by: disposeBag)
        
        backAction.subscribe(onNext: { _ in
            coordinator.back()
        }).disposed(by: disposeBag)
        
        GlobalVariables.shared.favoriteType.bind(to: favoriteType).disposed(by: disposeBag)
    }
}

// MARK: SelectFavorite ViewModelOutput
extension SelectFavoriteViewModel: SelectFavoriteViewModelOutput {
    var favorite: Driver<String> {
        return favoriteType.asDriver(onErrorJustReturn: "")
    }
    
    var loading: Driver<ViewState> {
         let loading = activityIndicator.toLoadingState(observableResult: typesObservableResult)
        
          return loading
              .map { result -> ViewState in
                if result.isLoading {
                    return .loading
                } else {
                    if result.error != nil {
                        return .error
                    } else {
                        return .none
                    }
                }
          }.asDriver(onErrorJustReturn: .none)
    }
    
    var types: Driver<[SectionViewModelType<TypeTableCellViewModel>]> {
        return typesItemsBehaviorRelay.asDriver()
    }
}
