//
//  VMProtocolComponent.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation

// 检查ViewModel所遵循协议
struct VMProtocolComponent : OptionSet {
    var rawValue: Int
    static let hud = VMProtocolComponent(rawValue: 1)
    static let loading = VMProtocolComponent(rawValue: 1 << 1)
    static let refresh = VMProtocolComponent(rawValue: 1 << 2)
}

protocol ProtocolComponent {
    
}

extension ProtocolComponent {
    var component : VMProtocolComponent{
        var protocolComponent = VMProtocolComponent()
        if self is HasRefreshComponents {
            protocolComponent.rawValue += VMProtocolComponent.refresh.rawValue
        }
        return protocolComponent
    }
}
