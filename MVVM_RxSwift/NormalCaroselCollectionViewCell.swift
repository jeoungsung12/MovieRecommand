//
//  NormalCaroselCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/26.
//

import Foundation
import UIKit
import SnapKit

class NormalCaroselCollectionViewCell : UICollectionViewCell {
    static let id : String = "NormalCell"
    //MARK: - UI Components
    private let mainImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
extension NormalCaroselCollectionViewCell {
    private func setLayout() {
        self.addSubview(mainImage)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        mainImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainImage.snp.bottom).offset(8)
            make.height.equalTo(15)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(15)
        }
    }
    public func config(imageUrl : String, title : String, subTitle : String) {
        if let url = URL(string: imageUrl) {
            self.mainImage.kf.setImage(with: url)
        }
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
}
