import UIKit
import SnapKit

class SubscribeNameView: UIView {
    
    var backgroundImageView = UIImageView()
    var titleLabel = UILabel()
    var nameTitleLabel = UILabel()
    var nameInput = UITextField()
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
        setupTitleLabel()
        setupNameLabel()
        setupNameInput()
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
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.text = R.string.pokemonFinder.subscribeNameTitle()
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.right.equalToSuperview().inset(32)
        }
    }
    
    private func setupNameLabel() {
        addSubview(nameTitleLabel)
        nameTitleLabel.numberOfLines = 2
        nameTitleLabel.textColor = .white
        nameTitleLabel.font = .systemFont(ofSize: 24)
        nameTitleLabel.text = R.string.pokemonFinder.subscribeNameHintText()
        nameTitleLabel.snp_makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(1.3)
            make.left.right.equalToSuperview().inset(32)
        }
    }
    
    private func setupNameInput() {
        addSubview(nameInput)
        nameInput.textColor = .white
        nameInput.snp_makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(40)
        }
    }
    
    private func setupBottomBorder() {
        addSubview(bottomBorder)
        bottomBorder.backgroundColor = UIColor.white
        bottomBorder.snp_makeConstraints { make in
            make.top.equalTo(nameInput.snp.bottom).inset(1)
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
