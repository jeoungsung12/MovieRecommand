//
//  BigImageCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/07/08.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class BigImageCollectionViewCell : UICollectionViewCell {
    static let id = "BigImageCollectionViewCell"
    private let posterImage = UIImageView()
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let descLabel : UILabel = {
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
extension BigImageCollectionViewCell {
    private func setLayout() {
        self.addSubview(posterImage)
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(reviewLabel)
        stackView.addArrangedSubview(descLabel)
        
        posterImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(14)
            make.trailing.bottom.equalToSuperview().offset(-14)
        }
    }
    public func configure(title : String, overview: String, review: String, url: String) {
        self.titleLabel.text = title
        self.reviewLabel.text = review
        self.descLabel.text = overview
        if let imageURL = URL(string: url) {
            self.posterImage.kf.setImage(with: imageURL)
        }
    }
}
