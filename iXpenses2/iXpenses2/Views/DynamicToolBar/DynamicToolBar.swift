//
//  DynamicToolBar.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 23.03.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class DynamicToolBar: UIView {
    private var observedScrollView: UIScrollView
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private lazy var visualeffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThickMaterial)
        let newView = UIVisualEffectView(effect: effect)
        return newView
    }()
    
    public private(set) var disposeBag = DisposeBag()
    
    let effectRelay: BehaviorRelay<UIBlurEffect?> = .init(value: nil)
    var initialHeight: CGFloat
    
    var fullHeight: CGFloat {
        var fullHeight = initialHeight
        
        if #available(iOS 11.0, *) {
            fullHeight += superview?.safeAreaInsets.bottom ?? 0.0
        }
        
        return fullHeight
    }
    
    init(height: CGFloat, observedScrollView: UIScrollView) {
        self.observedScrollView = observedScrollView
        self.initialHeight = height
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        
        setup()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        visualeffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualeffectView)
        visualeffectView.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: visualeffectView.contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: visualeffectView.contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: visualeffectView.contentView.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: self.initialHeight),
            visualeffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualeffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualeffectView.topAnchor.constraint(equalTo: topAnchor),
            visualeffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func bind() {
//        let toolBarHeightDriver: Driver<CGRect> = rx.observe(\.bounds).asObservable()
//            .asDriver(onErrorJustReturn: bounds)
//        
//        let scrollViewTopContentInsetDriver: Driver<CGFloat> = BehaviorRelay<CGFloat>.init(value: self.observedScrollView.contentInset.top).asDriver()
//        
//        let mainDriver = Driver.combineLatest(observedScrollView.rx.contentOffset.asDriver(), observedScrollView.contentSizeDriver, observedScrollView.boundsDriver, toolBarHeightDriver, scrollViewTopContentInsetDriver)
//            
//        mainDriver.flatMapLatest { (contentOffset, contentSize, scrollViewBounds, toolBarHeight, scrollViewTopContentInset) -> Driver<UIBlurEffect?> in
//            
//            let visibleContentHeight: CGFloat = contentSize.height - contentOffset.y - scrollViewTopContentInset
//              
//            if visibleContentHeight >= (scrollViewBounds.height - toolBarHeight.height) {
//                return BehaviorRelay<UIBlurEffect?>.init(value: UIBlurEffect(style: .systemUltraThinMaterial)).asDriver()
//            } else {
//                return BehaviorRelay<UIBlurEffect?>.init(value: nil).asDriver()
//            }
//        }.distinctUntilChanged()
//            .withUnretained(self)
//            .drive(onNext: { owner, effect in
//                owner.visualeffectView.effect = effect
//            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func addNewSubviews(_ newSubviews: [UIView]) {
        stackView.setArrangedSubviews(newSubviews)
    }
}

extension UIView {
    static var flexibleSpacer: UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return spacer
    }
}

extension UIStackView {
    func setArrangedSubviews(_ newSubViews: [UIView]) {
        for v in arrangedSubviews {
            removeArrangedSubview(v)
        }
        
        for v in newSubViews {
            addArrangedSubview(v)
        }
    }
}

public extension UIViewController {
    func addDynamicToolBar(with height: CGFloat, observedScrollView: UIScrollView, views: [UIView]) {
        let toolbar = DynamicToolBar(height: height, observedScrollView: observedScrollView)
        
        view.addSubview(toolbar)
        view.bringSubviewToFront(toolbar)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        var fullHeight = height
        
        if let root = UIApplication.shared.keyWindow?.rootViewController {
            fullHeight += root.view.safeAreaInsets.bottom
        }

        toolbar.Height == fullHeight
        toolbar.Leading == view.Leading
        toolbar.Trailing == view.Trailing
        toolbar.Bottom == view.Bottom
        
        toolbar.addNewSubviews(views)
    }
}
