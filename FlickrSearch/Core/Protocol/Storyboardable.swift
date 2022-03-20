//
//  Storyboardable.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import UIKit

protocol Storyboardable: IdentifyProtocol {
    
    static var storyboardKey: StoryboardNameKey { get }
    
}

extension Storyboardable {
    static func instantiate() -> Self {
        assert(storyboardKey != .empty, "Implement storyboardKey")
        return UIStoryboard(name: storyboardKey.rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: Self.identify()) as! Self
    }
}

extension Storyboardable where Self: ViewControllerBuilderType {
    static func instantiate() -> Self {
        assertionFailure("Use \"instantiate(with)\" instead")
        return UIViewController() as! Self
    }
}

struct StoryboardNameKey: RawRepresentable {
    
    var rawValue: String
    
    static let empty = StoryboardNameKey(rawValue: "empty")
    
}

// MARK:- extension
extension StoryboardNameKey {
    static let home = StoryboardNameKey(rawValue: "HomeController")
}
