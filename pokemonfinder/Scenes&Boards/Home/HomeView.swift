import UIKit
import SnapKit

class HomeView: UIView {
    
    var viewHeader = UIView()
    var headerLabel = UILabel()
    
    var stateContainerView = StatefulView()
    
    var typeCollectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .horizontal
         layout.minimumLineSpacing = 30
         layout.itemSize = CGSize(width: 70, height: 80)
         return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    var tableViewTitleLabel = UILabel()
    var tableViewOrderNameLabel = UILabel()
    var arrowOrderName = UIImageView()
    var pokemonTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: Setup
    private func setup() {
        backgroundColor = .white
        setupHeaderView()
        setupHeaderLabel()
        setupStateContainerView()
    }
    
    private func setupHeaderView() {
        addSubview(viewHeader)
        viewHeader.backgroundColor = .systemGreen
        viewHeader.snp_makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    private func setupHeaderLabel() {
        viewHeader.addSubview(headerLabel)
        headerLabel.text = R.string.pokemonFinder.pokemonHeaderLabelTitle()
        headerLabel.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(12)
        }
    }
    
    private func setupStateContainerView() {
        addSubview(stateContainerView)
        stateContainerView.snp_makeConstraints {  make in
            make.top.equalTo(viewHeader.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    func remakeCollectionViewConstraints() {
        stateContainerView.addSubview(typeCollectionView)
        typeCollectionView.backgroundColor = .white
        typeCollectionView.snp_makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    func remakeTableViewConstraints() {
        stateContainerView.addSubview(pokemonTableView)
        pokemonTableView.rowHeight = 70
        pokemonTableView.snp_makeConstraints { make in
            make.height.equalToSuperview().dividedBy(1.5)
            make.bottom.left.right.equalToSuperview()
        }
        setupTableTitle()
        setupNameOrder()
        setupOrderArrow()
    }
    
    private func setupTableTitle() {
        stateContainerView.addSubview(tableViewTitleLabel)
        tableViewTitleLabel.text = R.string.pokemonFinder.pokemonLabelTitle()
        tableViewTitleLabel.snp_makeConstraints { make in
            make.bottom.equalTo(pokemonTableView.snp.top)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(80)
        }
    }
    
    private func setupNameOrder() {
        stateContainerView.addSubview(tableViewOrderNameLabel)
        tableViewOrderNameLabel.text = R.string.pokemonFinder.nameLabelTitle()
        tableViewOrderNameLabel.snp_makeConstraints { make in
            make.bottom.equalTo(pokemonTableView.snp.top)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(80)
        }
    }
    
    private func setupOrderArrow() {
        stateContainerView.addSubview(arrowOrderName)
        arrowOrderName.image = R.image.ic_arrow_up()
        arrowOrderName.contentMode = .scaleAspectFit
        arrowOrderName.snp_makeConstraints { make in
            make.centerY.equalTo(tableViewOrderNameLabel.snp.centerY)
            make.right.equalToSuperview().inset(8)
        }
    }
}
