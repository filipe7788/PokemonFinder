import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInput {
    var didLoad: PublishSubject<Void> { get }
    var reload: PublishSubject<Void> { get }
    var favoriteTypeSubject: PublishSubject<String> { get }
}

protocol HomeViewModelOutput {
    var types: Driver<[SectionViewModelType<TypeCollectionCellViewModel>]> { get }
    var pokemons: Driver<[SectionViewModelType<PokemonCellViewModel>]> { get }
    var loading: Driver<ViewState> { get }
}

protocol HomeViewModelProtocol: ViewModel {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
}

struct HomeViewModel: HomeViewModelInput, HomeViewModelProtocol {
    var inputs: HomeViewModelInput { return self }
    var outputs: HomeViewModelOutput { return self }
    
    // MARK: Home ViewModelInput
    let didLoad = PublishSubject<Void>()
    let reload = PublishSubject<Void>()
    let favoriteTypeSubject = PublishSubject<String>()
    // MARK: Variables
    private var typesItemsBehaviorRelay = BehaviorRelay<[SectionViewModelType<TypeCollectionCellViewModel>]>(value: [])
    private var typesObservableResult: Observable<Result<[Type]>>
    
    private var pokemonsItemsBehaviorRelay = BehaviorRelay<[SectionViewModelType<PokemonCellViewModel>]>(value: [])
    private var pokemonsObservableResult: Observable<Result<[Pokemon]>>
    
    private var activityIndicator: ActivityIndicator
    private var disposeBag = DisposeBag()
    
    // MARK: Init
    init(favoriteType: String) {
        let indicator = ActivityIndicator()
        self.activityIndicator = indicator
        
        favoriteTypeSubject.onNext(favoriteType)
        
        typesObservableResult = Observable.merge(didLoad, reload).flatMap({ _ in
            return API.rx.getTypes().trackActivity(indicator)
        }).share()
        
        typesObservableResult.map { $0.failure }
            .unwrap().map { ($0, nil) }
            .bind(to: ApiErrorHandler.sharedInstance.rx.handleError)
            .disposed(by: disposeBag)
        
        typesObservableResult
            .map { $0.value }
            .unwrap()
            .map({ itens in
            return [SectionViewModelType<TypeCollectionCellViewModel>(viewModels: itens.map {
                TypeCollectionCellViewModel(type: $0)})]
            })
            .bind(to: typesItemsBehaviorRelay)
            .disposed(by: disposeBag)
        
        pokemonsObservableResult = Observable.merge(didLoad, reload).flatMap { _ in
            return API.rx.getPokemons().trackActivity(indicator)
        }.share()
        
        pokemonsObservableResult.map { $0.failure }
            .unwrap().map { ($0, nil) }
            .bind(to: ApiErrorHandler.sharedInstance.rx.handleError)
            .disposed(by: disposeBag)
        
        pokemonsObservableResult
            .map { $0.value }
            .unwrap()
            .map({ itens in
                let distinctPokemons = itens.removingDuplicates().sorted(by: { pokemon, _ in
                    pokemon.type.first == favoriteType })
            return [SectionViewModelType<PokemonCellViewModel>(viewModels: distinctPokemons.map { item in
                PokemonCellViewModel(pokemon: item)})]
            })
            .bind(to: pokemonsItemsBehaviorRelay)
            .disposed(by: disposeBag)
    }
}

// MARK: Home ViewModelOutput
extension HomeViewModel: HomeViewModelOutput {
    
    var pokemons: Driver<[SectionViewModelType<PokemonCellViewModel>]> {
        return pokemonsItemsBehaviorRelay.asDriver()
    }
    
    var types: Driver<[SectionViewModelType<TypeCollectionCellViewModel>]> {
        return typesItemsBehaviorRelay.asDriver()
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
}
