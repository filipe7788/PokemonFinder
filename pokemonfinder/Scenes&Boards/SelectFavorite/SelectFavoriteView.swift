import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SelectFavoriteView: UIView {
    
    var backgroundView = UIView()
    var innerView = UIView()
    var titleLabel = UILabel()
    var closeButton = UIButton()
    var separatorView = UIView()
    var stateContainerView = StatefulView()
    var favoriteTableView = UITableView()
    var bottomView = UIView()
    var bottomButtom = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: Setup
    private func setup() {
        backgroundColor = .clear
        setupBackgroundView()
        setupInnerView()
        setupTopView()
        setupSeparatorView()
        setupCloseButton()
        setupStateView()
        setupBottomView()
        setupConfirmButton()
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundView)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.isOpaque = false

        backgroundView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupInnerView() {
        addSubview(innerView)
        innerView.backgroundColor = .white
        innerView.snp_makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.6)
        }
    }
    
    private func setupTopView() {
        innerView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 19)
        titleLabel.numberOfLines = 2
        titleLabel.text = R.string.pokemonFinder.selectFavoriteTypeTitle()
        titleLabel.snp_makeConstraints { make in
            make.top.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().inset(80)
        }
    }
    
    private func setupCloseButton() {
        innerView.addSubview(closeButton)
        closeButton.setImage(R.image.ic_close(), for: .normal)
        closeButton.snp_makeConstraints { make in
            make.top.right.equalToSuperview().inset(24)
            make.width.equalTo(30)
        }
    }

    private func setupSeparatorView() {
        innerView.addSubview(separatorView)
        separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        separatorView.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
    }
    
    private func setupStateView() {
        innerView.addSubview(stateContainerView)
        stateContainerView.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
            make.right.equalToSuperview().inset(8)
            make.top.equalTo(separatorView.snp.bottom).offset(8)
        }
    }
    
    func remakeTableViewConstraints() {
        stateContainerView.addSubview(favoriteTableView)
        favoriteTableView.rowHeight = 80
        favoriteTableView.allowsSelection = false
        favoriteTableView.backgroundView?.backgroundColor = .clear
        favoriteTableView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
    }
    
    private func setupBottomView() {
        innerView.addSubview(bottomView)
        bottomView.snp_makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    private func setupConfirmButton() {
        bottomView.addSubview(bottomButtom)
        bottomButtom.backgroundColor = UIColor.init(red: 241/255, green: 30/255, blue: 117/255, alpha: 1)
        bottomButtom.setTitle(R.string.pokemonFinder.confirmButtonTitle(), for: .normal)
        bottomButtom.layer.cornerRadius = 10
        bottomButtom.isUserInteractionEnabled = false
        bottomButtom.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.right.left.equalToSuperview().inset(24)
        }
    }
}

extension Reactive where Base: SelectFavoriteView {

    var enableButton: Binder<String> {
        return Binder(self.base) { control, value in
            if value != "" {
                control.bottomButtom.isUserInteractionEnabled = true
            } else {
                control.bottomButtom.isUserInteractionEnabled = false
            }
        }
    }
}
