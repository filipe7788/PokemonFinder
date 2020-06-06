import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class PokemonCell: UITableViewCell {
    var typeImageView = UIImageView()
    var typeNameLabel = UILabel()

    var disposeBag = DisposeBag()
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
      setupTypeImageView()
      setupTypeNameLabel()
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
    
    var viewModel: PokemonCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    fileprivate func bindViewModel() {
        if let imageUrl = URL(string: viewModel.pokemon.thumbnailImage) {
            typeImageView.af_setImage(withURL: imageUrl)
        }
        typeNameLabel.text = viewModel.pokemon.name
    }
}
