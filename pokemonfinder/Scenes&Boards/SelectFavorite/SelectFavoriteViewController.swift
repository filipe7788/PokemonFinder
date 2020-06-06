import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SelectFavoriteViewController: UIViewController {
    private var mainView = SelectFavoriteView()
    private var viewModel: SelectFavoriteViewModelProtocol!
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionViewModelType<TypeTableCellViewModel>>(configureCell: { _, _, _, _ -> UITableViewCell in
        return UITableViewCell()
    })
    
    let disposeBag = DisposeBag()
    
    // MARK: Init
    init(viewModel: SelectFavoriteViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutputs()
        setupInputs()
        mainView.remakeTableViewConstraints()
        viewModel.inputs.didLoad.onNext(())
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: Setup
    private func setupInputs() {
        mainView
             .backgroundView
             .rx
             .tapGesture()
             .when(.recognized)
             .map { _ in ()}
             .bind(to: viewModel.inputs.backAction)
             .disposed(by: disposeBag)
        
        mainView
             .bottomButtom
             .rx
             .tapGesture()
             .when(.recognized)
             .map { _ in ()}
             .bind(to: viewModel.inputs.backAction)
             .disposed(by: disposeBag)
        
        mainView
             .closeButton
             .rx
             .tapGesture()
             .when(.recognized)
             .map { _ in ()}
             .bind(to: viewModel.inputs.backAction)
             .disposed(by: disposeBag)
        
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
        viewModel
            .outputs
            .loading
            .drive(mainView.stateContainerView.rx.state)
            .disposed(by: disposeBag)
        
        let identifier = String(describing: TypeTableCell.self)
        mainView.favoriteTableView.register(TypeTableCell.self, forCellReuseIdentifier: identifier)
        dataSource.configureCell = { _, tableView, indexPath, itemViewModel in
            let cell = (tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TypeTableCell)!
            cell.viewModel = itemViewModel            
            return cell
        }
        
        viewModel
            .outputs
            .types
            .drive(mainView.favoriteTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .favorite
            .drive(mainView.rx.enableButton)
            .disposed(by: disposeBag)
    }
}
