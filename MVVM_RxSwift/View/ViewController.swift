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
    case banner
    case horizotional(String)
    case vertical(String)
}
//셀
enum Item : Hashable {
    case normal(Content)
    case bigImage(Movie)
    case list(Movie)
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
        view.register(BigImageCollectionViewCell.self, forCellWithReuseIdentifier: BigImageCollectionViewCell.id)
        view.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.id)
        view.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader ,withReuseIdentifier: HeaderView.id)
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
            let items = tvList.map { return Item.normal(Content(tv: $0)) }
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
        }
        .disposed(by: disposeBag)
        output.moList.bind { moList in
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            let bigImageList = moList.nowPlaying.results.map { movie in
                return Item.bigImage(movie)
            }
            let bannerSection = Section.banner
            snapshot.appendSections([bannerSection])
            snapshot.appendItems(bigImageList, toSection: bannerSection)
            
            let horizontalSection = Section.horizotional("Popular Movies")
            let normalList = moList.popular.results.map { movie in
                return Item.normal(Content(movie: movie))
            }
            snapshot.appendSections([horizontalSection])
            snapshot.appendItems(normalList, toSection: horizontalSection)
            let verticalSection = Section.vertical("Upcoming Movies")
            let itemList = moList.upcoming.results.map { movie in
                return Item.list(movie)
            }
            snapshot.appendSections([verticalSection])
            snapshot.appendItems(itemList, toSection: verticalSection)
            self.dataSource?.apply(snapshot)
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
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .banner:
                return self?.createBannerSection()
            case .horizotional:
                return self?.createHorizontalSection()
            case .vertical:
                return self?.createVerticalSection()
            default:
                return self?.createDoubleSection()
            }
        }, configuration: config)
    }
    //MARK: - Vertical Section
    private func createVerticalSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        //header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        return section
    }
    //MARK: - Horizontal Section
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        //header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        return section
    }
    //MARK: - Banner Section
    private func createBannerSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(640))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    //MARK: - Main Section
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
            case .normal(let contentData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: indexPath) as? NormalCollectionViewCell
                cell?.config(imageUrl: contentData.posterURL , titleLabel: contentData.title , reviewLabel: "⭐️ \(contentData.vote)", descLabel: contentData.overview )
                return cell ?? nil
            case .bigImage(let movieData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCollectionViewCell.id, for: indexPath) as? BigImageCollectionViewCell
                cell?.configure(title: movieData.title, overview: movieData.overview, review: "⭐️ \(movieData.vote)", url: movieData.posterURL)
                return cell
            case .list(let movieData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.id, for: indexPath) as? ListCollectionViewCell
                cell?.configure(title: movieData.title, releaseDate: movieData.releaseDate, url: movieData.posterURL)
                return cell
            }
        })
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .horizotional(let title):
                (header as? HeaderView)?.configure(title: title)
            case .vertical(let title):
                (header as? HeaderView)?.configure(title: title)
            default:
                print("Default")
            }
            return header
        }
    }
}
