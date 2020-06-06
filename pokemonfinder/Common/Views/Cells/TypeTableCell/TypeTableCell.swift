import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class TypeTableCell: UITableViewCell {
    var typeImageView = UIImageView()
    var typeNameLabel = UILabel()
    var isSelectedImageView = UIImageView()

    var disposeBag = DisposeBag()
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubscribers() {
        isSelectedImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let this = self else { return }
                GlobalVariables.shared.favoriteType.onNext(this.viewModel.type.name)
            })
            .disposed(by: disposeBag)
        
        GlobalVariables.shared.favoriteType.subscribe(onNext: { [weak self] type in
            guard let this = self else { return }

            if this.viewModel.type.name == type {
                this.isSelectedImageView.image = R.image.ic_radio_on()
            } else {
                this.isSelectedImageView.image = R.image.ic_radio_off()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setup() {
      setupTypeImageView()
      setupTypeNameLabel()
      setupIsSelectedImageView()
    }
    
    private func setupTypeImageView() {
        addSubview(typeImageView)
        typeImageView.contentMode = .scaleAspectFit
        typeImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(60)
        }
    }
    
    private func setupTypeNameLabel() {
        addSubview(typeNameLabel)
        typeNameLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(typeImageView.snp.right).offset(24)
            make.right.equalToSuperview().inset(60)
        }
    }
    
    private func setupIsSelectedImageView() {
        addSubview(isSelectedImageView)
        isSelectedImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
            make.height.width.equalTo(30)
        }
    }
    
    var viewModel: TypeTableCellViewModel! {
        didSet {
            bindViewModel()
            setupSubscribers()
        }
    }
    
    fileprivate func bindViewModel() {
        if let imageUrl = URL(string: viewModel.type.thumbnailImage) {
            typeImageView.af_setImage(withURL: imageUrl)
        }
        typeNameLabel.text = viewModel.type.name
    }
}
