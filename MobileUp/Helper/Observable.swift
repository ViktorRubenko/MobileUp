//
//  Observable.swift
//  MobileUp
//
//  Created by Victor Rubenko on 28.03.2022.
//

import Foundation

final class Observable<T> {
    typealias Listener = ((T) -> Void)
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    private var listener: Listener?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
    }
}
