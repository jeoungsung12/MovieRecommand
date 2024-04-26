//
//  ViewController.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    //MARK: - UI Components
    //컬렉션 뷰
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var dataSource : UICollectionViewDiffableDataSource<Section,Item>?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCollection()
        setDataSource()
        setSnapShot()
    }
}
//MARK: - UI Navigation

//MARK: - UI Collection
extension ViewController {
    private func setCollection() {
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.id)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createBannerSection()
//            case 1:
//
//            case 2:
//
            default:
                return self.createBannerSection()
            }
        })
    }
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
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider : { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.id, for: indexPath) as? BannerCollectionViewCell else {
                return UICollectionViewCell()}
            
            switch itemIdentifier {
            case .banner(let item):
                cell.config(title: item.title, imageUrl: item.imageUrl)
                return cell
//            case .normalCarousel(let item):
//                return cell
//            case .listCarousel(let item):
//                return cell
            default:
                return cell
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
        dataSource?.apply(snapshot)
    }
}
//MARK: - UI Layout
extension ViewController {
    private func setLayout() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
