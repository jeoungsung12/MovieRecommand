//
//  BannerCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/04/26.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class BannerCollectionViewCell : UICollectionViewCell {
    static let id : String = "BannerCell"
    private let titleLabel = UILabel()
    private let backgroundImage = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout()
extension BannerCollectionViewCell {
    private func setUI() {
        //Snapkit AutoLayout
        self.addSubview(backgroundImage)
        self.addSubview(titleLabel)
        //constraiant
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    public func config(title: String, imageUrl : String) {
        // title, image set
        self.titleLabel.text = title
        if let url = URL(string: imageUrl){
            self.backgroundImage.kf.setImage(with: url)
        }
    }
}
