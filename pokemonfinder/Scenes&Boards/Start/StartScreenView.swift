import UIKit
import SnapKit
import RxCocoa
import RxSwift

class StartScreenView: UIView {
    
    var backgroundImageView = UIImageView()
    var logoStackView = UIStackView()
    var pokemonImageView = UIImageView()
    var finderImageView = UIImageView()
    var pikachuImageView = UIImageView()
    var letsGoButton = UIButton()
    
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
        setupLogoStackView()
        setupPikachuImageView()
        setupLetsGoButton()
    }
    
    private func setupBackgroundImageView() {
        addSubview(backgroundImageView)
        backgroundImageView.image = R.image.img_background()
        backgroundImageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupLogoStackView() {
        addSubview(logoStackView)
        logoStackView.distribution = .fill
        logoStackView.axis = .vertical
        logoStackView.spacing = -16
        logoStackView.alignment = .fill
        logoStackView.snp_makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(303)
            make.height.equalTo(144)
        }
        setupPokemonImageView()
        setupFinderImageView()
    }
    
    private func setupPokemonImageView() {
        logoStackView.addArrangedSubview(pokemonImageView)
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.image = R.image.ic_logo()
        pokemonImageView.snp_makeConstraints { make in
            make.height.equalTo(111)
            make.width.equalTo(303)
        }
    }

    private func setupFinderImageView() {
        logoStackView.addArrangedSubview(finderImageView)
        finderImageView.image = R.image.ic_finder()
        finderImageView.contentMode = .scaleAspectFit
        finderImageView.snp_makeConstraints { make in
            make.height.equalTo(49)
            make.width.equalTo(127)
        }
    }
    
    private func setupPikachuImageView() {
        addSubview(pikachuImageView)
        pikachuImageView.image = R.image.ic_pikachu()
        pikachuImageView.snp_makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(237)
            make.width.equalTo(230)
        }
    }
    
    private func setupLetsGoButton() {
        addSubview(letsGoButton)
        letsGoButton.backgroundColor = UIColor.init(red: 241/255, green: 30/255, blue: 117/255, alpha: 1)
        letsGoButton.setTitle(R.string.pokemonFinder.letsGoButtonTitle(), for: .normal)
        letsGoButton.isHidden = true
        letsGoButton.layer.cornerRadius = 10
        letsGoButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.right.left.equalToSuperview().inset(24)
        }
    }
}

extension Reactive where Base: StartScreenView {

    var animateLogo: Binder<Void> {
        return Binder(self.base) { control, _ in
            UIView.animate(withDuration: 0.8, delay: 0.3, animations: {
                control.logoStackView.transform = CGAffineTransform(translationX: 0, y: -200)
            }, completion: { _ in
                control.letsGoButton.isHidden = false
            })
        }
    }
}
