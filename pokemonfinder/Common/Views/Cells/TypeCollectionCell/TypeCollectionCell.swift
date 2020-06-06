import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class TypeCollectionCell: UICollectionViewCell {
    var typeImageView = UIImageView()
    var typeNameLabel = UILabel()

    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
      backgroundColor = .white
      setupTypeImageView()
      setupTypeNameLabel()
    }
    
    private func setupTypeImageView() {
        addSubview(typeImageView)
        typeImageView.contentMode = .scaleAspectFit
        typeImageView.snp_makeConstraints { make in
            make.center.equalToSuperview()

            make.height.width.equalTo(80)
        }
    }
    
    private func setupTypeNameLabel() {
        addSubview(typeNameLabel)
        typeNameLabel.snp_makeConstraints { make in
            make.top.equalTo(typeImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

    var viewModel: TypeCollectionCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    fileprivate func bindViewModel() {
        if let imageUrl = URL(string: viewModel.type.thumbnailImage) {
            typeImageView.af_setImage(withURL: imageUrl)
        }
        typeNameLabel.text = viewModel.type.name
    }
}
