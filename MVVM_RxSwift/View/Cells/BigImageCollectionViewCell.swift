//
//  BigImageCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/07/08.
//

import Foundation
import UIKit

final class BigImageCollectionViewCell : UICollectionViewCell {
    static let id = "BigImageCollectionViewCell"
    private let posterImage = UIImageView()
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
