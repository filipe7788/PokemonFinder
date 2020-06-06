import UIKit
import RxSwift
import RxCocoa

class ChooseFavoriteViewController: UIViewController {
    private var mainView = ChooseFavoriteView()
    private var viewModel: ChooseFavoriteViewModelProtocol!
    
    let disposeBag = DisposeBag()
    
    // MARK: Init
    init(viewModel: ChooseFavoriteViewModelProtocol) {
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
        
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: Setup
    private func setupInputs() {
        mainView
            .favoriteInput
            .rx
            .tapGesture()
            .when(.recognized)
            .map { _ in ()}
            .bind(to: viewModel.inputs.touchTextField)
            .disposed(by: disposeBag)
        
        mainView
             .backButtonView
             .rx
             .tapGesture()
             .when(.recognized)
             .map { _ in ()}
             .bind(to: viewModel.inputs.backAction)
             .disposed(by: disposeBag)
        
        mainView
             .nextButtonImageView
             .rx
             .tapGesture()
             .when(.recognized)
             .map { _ in ()}
            .bind(to: viewModel.inputs.nextAction)
             .disposed(by: disposeBag)
        
    }
    
    func setupOutputs() {
        viewModel
            .outputs
            .userName
            .drive(mainView.rx.username)
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .favoriteTypeName
            .drive(mainView.favoriteInput.rx.text)
            .disposed(by: disposeBag)
    }
}
