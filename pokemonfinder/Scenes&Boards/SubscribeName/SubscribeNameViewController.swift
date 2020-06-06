import UIKit
import RxSwift
import RxCocoa

class SubscribeNameViewController: UIViewController {
    private var mainView = SubscribeNameView()
    private var viewModel: SubscribeNameViewModelProtocol!
    
    let disposeBag = DisposeBag()
    
    // MARK: Init
    init(viewModel: SubscribeNameViewModelProtocol) {
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
            .nextButtonImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .map { _ in ()}
            .bind(to: viewModel.inputs.nextAction)
            .disposed(by: disposeBag)
        
        mainView
            .nameInput
            .rx
            .text
            .unwrap()
            .bind(to: viewModel.inputs.userName)
            .disposed(by: disposeBag)
        
    }
    
    func setupOutputs() {
    }
}
