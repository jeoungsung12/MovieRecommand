//
//  ListCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/07/13.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class ListCollectionViewCell : UICollectionViewCell {
    static let id = "ListCollectionViewCell"
    private let image : UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let releaseDateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame : frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
extension ListCollectionViewCell {
    private func setLayout() {
        self.addSubview(image)
        self.addSubview(titleLabel)
        self.addSubview(releaseDateLabel)
        image.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.top.equalToSuperview()
        }
        releaseDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
    public func configure(title: String, releaseDate : String, url : String) {
        self.titleLabel.text = title
        self.releaseDateLabel.text = releaseDate
        if let imageURL = URL(string: url) {
            self.image.kf.setImage(with: imageURL)
        }
    }
}
