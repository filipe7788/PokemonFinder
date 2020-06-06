import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ChooseFavoriteView: UIView {
    
    var backgroundImageView = UIImageView()
    var backButtonView = UIImageView()
    var titleLabel = UILabel()
    var favoriteTitleLabel = UILabel()
    var favoriteInput = UITextField()
    var bottomBorder = UIView()
    var nextButtonImageView = UIImageView()

    override init(frame: CGRect) {
       super.init(frame: frame)
       setup()
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError()
    }

    // MARK: Setup
    private func setup() {
       setupBackgroundImageView()
       setupBackButtonView()
       setupTitleLabel()
       setupFavoriteLabel()
       setupFavoriteInput()
       setupBottomBorder()
       setupNextButtonImageView()
    }

    private func setupBackgroundImageView() {
       addSubview(backgroundImageView)
       backgroundImageView.image = R.image.img_background()
       backgroundImageView.snp_makeConstraints { make in
           make.edges.equalToSuperview()
       }
    }
    
    private func setupBackButtonView() {
        addSubview(backButtonView)
        backButtonView.image = R.image.ic_arrow_right()
        backButtonView.contentMode = .scaleAspectFit
        backButtonView.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(50)
            make.width.equalTo(40)
        }
    }

    private func setupTitleLabel() {
       addSubview(titleLabel)
       titleLabel.textColor = .white
       titleLabel.font = .systemFont(ofSize: 24)
       titleLabel.snp_makeConstraints { make in
           make.top.equalToSuperview().offset(80)
           make.left.right.equalToSuperview().inset(32)
       }
    }

    private func setupFavoriteLabel() {
       addSubview(favoriteTitleLabel)
       favoriteTitleLabel.numberOfLines = 2
       favoriteTitleLabel.textColor = .white
       favoriteTitleLabel.font = .systemFont(ofSize: 24)
       favoriteTitleLabel.text = R.string.pokemonFinder.chooseFavoriteHintText()
       favoriteTitleLabel.snp_makeConstraints { make in
           make.centerY.equalToSuperview().dividedBy(1.3)
           make.left.right.equalToSuperview().inset(32)
       }
    }

    private func setupFavoriteInput() {
       addSubview(favoriteInput)
       favoriteInput.inputView = UIView()
       favoriteInput.inputAccessoryView = UIView()
       favoriteInput.tintColor = .clear
       favoriteInput.textColor = .white
       favoriteInput.rightViewMode = .always
       let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
       let image = R.image.ic_arrow_down()
       imageView.image = image
       favoriteInput.rightView = imageView
       favoriteInput.snp_makeConstraints { make in
           make.top.equalTo(favoriteTitleLabel.snp.bottom).offset(8)
           make.left.right.equalToSuperview().inset(32)
           make.height.equalTo(40)
       }
    }

    private func setupBottomBorder() {
       addSubview(bottomBorder)
       bottomBorder.backgroundColor = UIColor.white
       bottomBorder.snp_makeConstraints { make in
           make.top.equalTo(favoriteInput.snp.bottom).inset(1)
           make.height.equalTo(1)
           make.left.right.equalToSuperview().inset(32)
       }
    }

    private func setupNextButtonImageView() {
       addSubview(nextButtonImageView)
       nextButtonImageView.contentMode = .scaleAspectFit
       nextButtonImageView.image = R.image.ic_next()
       nextButtonImageView.snp_makeConstraints { make in
           make.bottom.equalToSuperview().inset(32)
           make.centerX.equalToSuperview()
           make.height.width.equalTo(60)
       }
    }
}

extension Reactive where Base: ChooseFavoriteView {

    var username: Binder<String> {
        return Binder(self.base) { control, value in
            control.titleLabel.text = R.string.pokemonFinder.chooseFavoriteTitle(value)
        }
    }
}
