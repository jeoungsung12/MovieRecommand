//
//  ListCarouselCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/27.
//

import Foundation
import UIKit
import Kingfisher

class ListCarouselCollectionViewCell : UICollectionViewCell {
    static let id : String = "ListCarouselCell"
    private let mainImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
extension ListCarouselCollectionViewCell {
    private func setLayout() {
        self.addSubview(mainImage)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        mainImage.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.width.equalTo(60)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(mainImage.snp.trailing).offset(8)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    public func config(imageUrl : String, title: String, subTitle: String?) {
        if let url = URL(string: imageUrl){
            self.mainImage.kf.setImage(with: url)
        }
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
}
