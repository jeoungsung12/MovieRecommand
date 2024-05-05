//
//  ViewController.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/26.
//

import UIKit
import SnapKit
import RxSwift
class ViewController: UIViewController {
    //MARK: - UI Components
    private let viewModel = ViewModel()
    private let buttonView = ButtonView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    //Subject - 이벤트를 발생시키면서 Observarble 형태도 되는 것.
    private let tvTrigger = PublishSubject<Void>()
    private let moTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var dataSource : UICollectionViewDiffableDataSource<Section,Item>?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setCollection()
        setDataSource()
        setSnapShot()
        setBindView()
    }
}
//MARK: - UI Navigation

//MARK: - UI Collection
extension ViewController {
    private func setCollection() {
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.id)
        collectionView.register(NormalCaroselCollectionViewCell.self, forCellWithReuseIdentifier: NormalCaroselCollectionViewCell.id)
        collectionView.register(ListCarouselCollectionViewCell.self, forCellWithReuseIdentifier: ListCarouselCollectionViewCell.id)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createBannerSection()
            case 1:
                return self.createNormalCarouselSection()
            case 2:
                return self.createListCarouselSection()
            default:
                return self.createBannerSection()
            }
        },configuration: config)
    }
    //MARK: - setCollectionLayout
    private func createBannerSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    private func createNormalCarouselSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    private func createListCarouselSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    //MARK: - setCollectionData
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider : { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .banner(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.id, for: indexPath) as? BannerCollectionViewCell else {
                    return UICollectionViewCell()}
                cell.config(title: item.title, imageUrl: item.imageUrl)
                return cell
            case .normalCarousel(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCaroselCollectionViewCell.id, for: indexPath) as? NormalCaroselCollectionViewCell else {
                    return UICollectionViewCell()}
                cell.config(imageUrl: item.imageUrl, title: item.title, subTitle: item.subTitle ?? "")
                return cell
            case .listCarousel(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCarouselCollectionViewCell.id, for: indexPath) as? ListCarouselCollectionViewCell else {
                    return UICollectionViewCell()}
                cell.config(imageUrl: item.imageUrl, title: item.title, subTitle: item.subTitle)
                return cell
//            default:
//                return UICollectionViewCell()
            }
        })
    }
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([Section(id: "Banner")])
        let bannerItems = [
            Item.banner(HomeItem(title: "교촌 치킨", subTitle: nil, imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.banner(HomeItem(title: "굽네 치킨", subTitle: nil, imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.banner(HomeItem(title: "푸라닭 치킨", subTitle: nil, imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg"))
        ]
        snapshot.appendItems(bannerItems, toSection: Section(id: "Banner"))
        
        snapshot.appendSections([Section(id: "NormalCarosel")])
        let normalItems = [
            Item.normalCarousel(HomeItem(title: "교촌치킨", subTitle: "간장 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.normalCarousel(HomeItem(title: "굽네치킨", subTitle: "오븐 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.normalCarousel(HomeItem(title: "푸라닭 치킨", subTitle: "차이니즈 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.normalCarousel(HomeItem(title: "후라이드 참 잘하는집", subTitle: "후라이드 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.normalCarousel(HomeItem(title: "페리카나", subTitle: "양념 후라이드 반반 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.normalCarousel(HomeItem(title: "BHC", subTitle: "뿌링클 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg"))
        ]
        snapshot.appendItems(normalItems, toSection: Section(id: "NormalCarosel"))
        
        snapshot.appendSections([Section(id: "ListCarosel")])
        let listItems = [
            Item.listCarousel(HomeItem(title: "교촌치킨", subTitle: "간장 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.listCarousel(HomeItem(title: "굽네치킨", subTitle: "오븐 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.listCarousel(HomeItem(title: "푸라닭 치킨", subTitle: "차이니즈 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.listCarousel(HomeItem(title: "후라이드 참 잘하는집", subTitle: "후라이드 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.listCarousel(HomeItem(title: "페리카나", subTitle: "양념 후라이드 반반 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg")),
            Item.listCarousel(HomeItem(title: "BHC", subTitle: "뿌링클 치킨", imageUrl: "https://static.onecms.io/wp-content/uploads/sites/43/2022/05/26/8805-CrispyFriedChicken-mfs-3x2-072.jpg"))
        ]
        snapshot.appendItems(listItems, toSection: Section(id: "ListCarosel"))
        
        dataSource?.apply(snapshot)
    }
}
//MARK: - UI Layout
extension ViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
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
        output.tvList.bind { tvList in
            print(tvList)
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
