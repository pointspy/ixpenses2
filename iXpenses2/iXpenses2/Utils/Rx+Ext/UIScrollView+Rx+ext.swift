//
//  UIScrollView+Rx+ext.swift
//  iXpenses2
//
//  Created by Pavel Lyskov on 23.03.2021.
//

import RxCocoa
import RxSwift

/** Reactive Extension for `UIScrollView`. */
extension Reactive where Base: UIScrollView {
    /** Reactive wrapper for `UIScrollView.contentSize` property. */
    var contentSize: ControlProperty<CGSize> {
        let source: Observable<CGSize> = self.observeWeakly(CGSize.self,
                                                            #keyPath(UIScrollView.contentSize),
                                                            options: [.initial, .new])
            .filter { $0 != nil }
            .map { $0! }
            .distinctUntilChanged()
            .take(until: deallocated)
        let observer = Binder(self.base) { (scroll: UIScrollView, contentSize: CGSize) in
            scroll.contentSize = contentSize
        }
        return ControlProperty(values: source, valueSink: observer)
    }
    
    /** Reactive wrapper for `UIScrollView.contentInset` property. */
    var contentInset: ControlProperty<UIEdgeInsets> {
        let source: Observable<UIEdgeInsets> = self.observeWeakly(UIEdgeInsets.self,
                                                                  #keyPath(UIScrollView.contentInset),
                                                                  options: [.initial, .new])
            .filter { $0 != nil }
            .map { $0! }
            .distinctUntilChanged()
            .take(until: deallocated)
        let observer = Binder(self.base) { (scroll: UIScrollView, contentInset: UIEdgeInsets) in
            scroll.contentInset = contentInset
        }
        return ControlProperty(values: source, valueSink: observer)
    }
}

