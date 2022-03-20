//
//  IdentifyProtocol.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
protocol IdentifyProtocol {
    static func identify() -> String
}

extension IdentifyProtocol {
    static func identify() -> String {
        return String(describing: self)
    }
}
