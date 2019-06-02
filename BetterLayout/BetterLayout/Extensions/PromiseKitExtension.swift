//
//  PromiseKitExtension.swift
//  Trading
//
//  Created by Vlad Che on 2/27/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import Foundation
import PromiseKit

func attempt<T>(_ maximumRetryCount: Int = 3,
                delay: DispatchTimeInterval = .milliseconds(1000),
                _ body: @escaping () -> Promise<T>) -> Promise<T> {
    var attempts = 0
    func attempt() -> Promise<T> {
        attempts += 1
        if attempts > 1 { print("attempt \(attempts)") }
        return body().recover { error -> Promise<T> in
            guard attempts < maximumRetryCount else { throw error }
            return after(delay).then(on: nil, attempt)
        }
    }
    return attempt()
}


/// Judicious use of __if__ *may* make chains more readable.
/// The closure is executed when the promise is resolved.
/// - Important: To use it like Swift if / else statements you must provide single-expresion closures to omit `return` keyword.
///     Example:
///```
/// func loadPrice() {
///     weak var `self` = self
///     let price: Promise<Float> = provider.getPrice()
///     if (price) { self?.update } .else { self?.showError }
/// }
///
/// func update(with price: Float) {
///     // update view
/// }
///
/// func show(_ error: Error) {
///     alert(error.localizedDescription)
/// }
///```
/// - Parameters:
///   - promise: promise
///   - body: The closure that is executed when this Promise is fulfilled.
/// - Returns: A new promise fulfilled as Void.
func іf<T, U: Thenable>(_ promise: U, _ body: @escaping () -> ((T) -> Void)? ) -> Promise<Void> where U.T == T {
    return promise.done { body()?($0) }
}

extension Thenable {
    func map<U>(_ keyPath: KeyPath<T, U>) -> Promise<U> {
        return self.map { $0[keyPath: keyPath] }
    }
}

extension CatchMixin {
    
    @discardableResult
    func `else`(_ body: @escaping () -> ((Error) -> Void)?) -> PromiseKit.PMKFinalizer {
        return `catch`{ body()?($0) }
    }
    
    @discardableResult
    func `catch`(_ body: @escaping () -> ((Error) -> Void)?) -> PromiseKit.PMKFinalizer {
        return `catch`{ body()?($0) }
    }
    
    func onErrorJustReturn(_ value: T) -> Guarantee<T> {
        return recover { _ in .value(value) }
    }
}
