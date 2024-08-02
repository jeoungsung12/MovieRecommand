//
//  ReviewViewController.swift
//  MVVM_RxSwift
//
//  Created by 정성윤 on 2024/07/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Foundation

final class ReviewViewContoller : UIViewController {
    private let disposeBag = DisposeBag()
    var tvData : Content
    init(tvData : Content) {
        self.tvData = tvData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let titleView : UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setBindView()
        setNavigatioin()
    }
}
//MARK: - UI Navigation
private extension ReviewViewContoller {
    private func setNavigatioin() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
}
//MARK: - UI Layout
private extension ReviewViewContoller {
    private func setLayout() {
        self.view.addSubview(image)
        self.view.addSubview(titleView)
        
        image.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(3)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        titleView.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}
//MARK: - Binding
private extension ReviewViewContoller {
    private func setBinding() {
        
    }
    private func setBindView() {
        if let url = URL(string: "https://image.tmdb.org/t/p/original\(tvData.posterURL)") {
            self.image.kf.setImage(with: url)
            self.titleView.text = "\(self.tvData.title)\n\n\(self.tvData.overview)"
        }
    }
}
//MARK: - Action
private extension ReviewViewContoller {
    
}
