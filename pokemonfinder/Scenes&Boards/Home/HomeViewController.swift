import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController {
    private var mainView = HomeView()
    private var viewModel: HomeViewModelProtocol!
    
    let disposeBag = DisposeBag()
    
    private let typesDataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModelType<TypeCollectionCellViewModel>>(configureCell: { _, _, _, _ -> UICollectionViewCell in
        return UICollectionViewCell()
    })
    
    private let pokemonDataSource = RxTableViewSectionedReloadDataSource<SectionViewModelType<PokemonCellViewModel>>(configureCell: { _, _, _, _ -> UITableViewCell in
        return UITableViewCell()
    })
    
    // MARK: Init
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.remakeTableViewConstraints()
        mainView.remakeCollectionViewConstraints()
        setupOutputs()
        setupInputs()
        viewModel.inputs.didLoad.onNext(())
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: Setup
    private func setupInputs() {
        mainView
            .stateContainerView
            .setAvailableViews(loadingView: DefaultLoadingStateView(loadType: .opaque),
                               errorView: DefaultErrorStateView(title: R.string.pokemonFinder.errorDefaultMessageTitle(), subtitle: R.string.pokemonFinder.errorDefaultMessageSubTitle()),
                               emptyView: DefaultEmptyStateView(title: R.string.pokemonFinder.emptyDefaultMessageTitle(), subtitle: R.string.pokemonFinder.emptyDefaultMessageSubTitle())
        )
        let reloadAction: (() -> Void) = { [weak self] in self?.viewModel.inputs.reload.onNext(()) }
        mainView.stateContainerView.setHandlers(errorView: reloadAction, emptyView: reloadAction)
    }
    
    func setupOutputs() {
       let typeIdentifier = String(describing: TypeCollectionCell.self)
       mainView
        .typeCollectionView
        .register(TypeCollectionCell.self,
                  forCellWithReuseIdentifier: typeIdentifier)
       
        typesDataSource.configureCell = { _, tableView, indexPath, itemViewModel in
            let cell = (tableView.dequeueReusableCell(withReuseIdentifier: typeIdentifier, for: indexPath) as? TypeCollectionCell)!
            cell.viewModel = itemViewModel
            return cell
       }
            
        let pokemonsIdentifier = String(describing: PokemonCell.self)
        mainView.pokemonTableView.register(PokemonCell.self, forCellReuseIdentifier: pokemonsIdentifier)
        pokemonDataSource.configureCell = { _, tableView, indexPath, itemViewModel in
            let cell = (tableView.dequeueReusableCell(withIdentifier: pokemonsIdentifier, for: indexPath) as? PokemonCell)!
            cell.viewModel = itemViewModel
            return cell
        }
        
        viewModel
            .outputs
            .types
            .drive(mainView.typeCollectionView.rx.items(dataSource: typesDataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .pokemons
            .drive(mainView.pokemonTableView.rx.items(dataSource: pokemonDataSource))
            .disposed(by: disposeBag)
        
        viewModel
           .outputs
           .loading
           .drive(mainView.stateContainerView.rx.state)
           .disposed(by: disposeBag)
    }
}
