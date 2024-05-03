//
//  ButtonView.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/05/03.
//

import Foundation
import UIKit
import SnapKit

class ButtonView : UIView {
    //MARK: - UI Components
    private let tvButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("TV", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.configuration = UIButton.Configuration.bordered()
        return btn
    }()
    private let movieButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Movie", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.configuration = UIButton.Configuration.bordered()
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UI Layout
extension ButtonView {
    private func setUI() {
        self.backgroundColor = .white
        self.addSubview(tvButton)
        self.addSubview(movieButton)
        
        tvButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
        }
        movieButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(tvButton.snp.trailing).offset(10)
        }
    }
}
