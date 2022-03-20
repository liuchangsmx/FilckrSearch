//
//  Extensionable.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation

public struct LCExtension<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol Extensionable {
    associatedtype ExtensionableType
    
    static var lc: LCExtension<ExtensionableType>.Type { get }

    var lc: LCExtension<ExtensionableType> { get }
}

extension Extensionable {
    public static var lc: LCExtension<Self>.Type {
        get {
            return LCExtension<Self>.self
        }
    }
    
    public var lc: LCExtension<Self> {
        get {
            return LCExtension(self)
        }
    }
}
