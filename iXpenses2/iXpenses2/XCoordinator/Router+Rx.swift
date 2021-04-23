//
//  Router+Rx.swift
//  XCoordinatorRx
//
//  Created by Paul Kraft on 28.08.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(XCoordinator) && canImport(RxSwift)

import RxSwift
import XCoordinator

public extension Router {
    /// Use this to access the reactive extensions of `Router` objects.
    var rx: Reactive<Self> {
        // swiftlint:disable:previous identifier_name
        Reactive(self)
    }
}

public extension Reactive where Base: Router {
    ///
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Parameter options:
    ///     Transition options, e.g. defining whether or not the transition should be animated.
    ///
    /// - Returns:
    ///     An observable informing about the completion of the transition.
    ///
    func trigger(_ route: Base.RouteType, with options: TransitionOptions) -> Observable<Void> {
        Observable.create { [base] observer -> Disposable in
            base.trigger(route, with: options) {
                observer.onNext(())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: Convenience methods

    ///
    /// This method transforms the completion block of a router's trigger method into an observable.
    ///
    /// It uses the default transition options as specified in `Router.trigger`.
    ///
    /// - Parameter route:
    ///     The route to be triggered.
    ///
    /// - Returns:
    ///     An observable informing about the completion of the transition.
    ///
    func trigger(_ route: Base.RouteType) -> Observable<Void> {
        trigger(route, with: TransitionOptions(animated: true))
    }

    
}

#endif
