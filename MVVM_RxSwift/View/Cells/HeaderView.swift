//
//  HeaderView.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/07/13.
//
import UIKit
import SnapKit
import Foundation

final class HeaderView : UICollectionReusableView {
    static let id : String =  "HeaderView"
    //MARK: - UI Components
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
extension HeaderView {
    private func setLayout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
    public func configure(title : String) {
        self.titleLabel.text = title
    }
}
