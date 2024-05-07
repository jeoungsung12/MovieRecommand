//
//  NormalCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/05/06.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit

class NormalCollectionViewCell : UICollectionViewCell {
    static let id : String = "NormalCollectionViewCell"
    private let image : UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2 //2줄까지 허용
        return label
    }()
    private let reviewLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private let descLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2 //2줄까지 허용
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
extension NormalCollectionViewCell {
    private func setLayout() {
        self.addSubview(image)
        self.addSubview(titleLabel)
        self.addSubview(reviewLabel)
        self.addSubview(descLabel)
        
        image.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
}
//MARK: - UI Config
extension NormalCollectionViewCell {
    public func config(imageUrl : String, titleLabel : String, reviewLabel : String, descLabel : String) {
        if let url = URL(string: "https://image.tmdb.org/t/p/original\(imageUrl)") {
            self.image.kf.setImage(with: url)
        }
        self.titleLabel.text = titleLabel
        self.reviewLabel.text = reviewLabel
        self.descLabel.text = descLabel
    }
}
