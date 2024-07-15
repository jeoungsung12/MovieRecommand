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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigatioin()
    }
}
//MARK: - UI Navigation
private extension ReviewViewContoller {
    private func setNavigatioin() {
        
    }
}
//MARK: - UI Layout
private extension ReviewViewContoller {
    private func setLayout() {
        
    }
}
//MARK: - Binding
private extension ReviewViewContoller {
    private func setBinding() {
        
    }
    private func BindView() {
        
    }
}
//MARK: - Action
private extension ReviewViewContoller {
    
}
