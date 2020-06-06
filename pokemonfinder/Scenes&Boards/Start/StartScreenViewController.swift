import UIKit
import RxSwift
import RxCocoa

class StartScreenViewController: UIViewController {
    private var mainView = StartScreenView()
    private var viewModel: StartScreenViewModelProtocol!
    
    let disposeBag = DisposeBag()
    
    // MARK: Init
    init(viewModel: StartScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputs()
        mainView.rx.animateLogo.onNext(())
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: Setup
    private func setupInputs() {
        mainView
            .letsGoButton
            .rx
            .tapGesture()
            .map { _ in ()}
            .bind(to: viewModel.inputs.start)
            .disposed(by: disposeBag)
    }
}
