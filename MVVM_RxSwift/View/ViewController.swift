//
//  ViewController.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/26.
//

import UIKit
import SnapKit
import RxSwift
//MARK: - ModernCollectionView
//레이아웃
enum Section : Hashable {
    case double
}
//셀
enum Item : Hashable {
    case normal(TV)
}

class ViewController: UIViewController {
    //MARK: - UI Components
    private let viewModel = ViewModel()
    private let buttonView = ButtonView()
    //Subject - 이벤트를 발생시키면서 Observarble 형태도 되는 것.
    private let tvTrigger = PublishSubject<Void>()
    private let moTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    //CollectionView
    lazy var collectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        view.register(NormalCollectionViewCell.self, forCellWithReuseIdentifier: NormalCollectionViewCell.id)
        return view
    }()
    private var dataSource : UICollectionViewDiffableDataSource<Section,Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //초기 세팅
        setLayout()
        setBinding()
        setBindView()
        setDatasource()
        setNavigation()
        //초기 로딩
        self.tvTrigger.onNext(())
    }
}
//MARK: - UI Navigation
extension ViewController {
    private func setNavigation() {
        self.view.backgroundColor = .white
    }
}
//MARK: - UI Collection

//MARK: - UI Layout
extension ViewController {
    private func setLayout() {
        self.view.addSubview(buttonView)
        self.view.addSubview(collectionView)
        buttonView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonView.snp.bottom)
        }
    }
}
//MARK: - Bind
extension ViewController {
    private func setBinding() {
        let input = ViewModel.Input(tvTrigger: tvTrigger.asObserver(), moTrigger: moTrigger.asObserver())
        let output = viewModel.transform(input: input)
        output.tvList.bind {[weak self] tvList in
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            let items = tvList.map { return Item.normal($0) }
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
        }
        .disposed(by: disposeBag)
        output.moList.bind { moList in
            print(moList)
        }
        .disposed(by: disposeBag)
    }
    private func setBindView() {
        buttonView.tvButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.tvTrigger.onNext(())
        }
        .disposed(by: disposeBag)
        buttonView.movieButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.moTrigger.onNext(())
        }
        .disposed(by: disposeBag)
    }
}
//MARK: - UI CollectionView
extension ViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self?.createDoubleSection()
            default:
                return self?.createDoubleSection()
            }
        }, configuration: config)
    }
    private func createDoubleSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        //section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .normal(let tvData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: indexPath) as? NormalCollectionViewCell
                cell?.config(imageUrl: tvData.poster_path ?? "", titleLabel: tvData.title ?? "", reviewLabel: "\(tvData.vote_average ?? 0.0)", descLabel: tvData.overview ?? "")
                return cell
            }
        })
    }
}
