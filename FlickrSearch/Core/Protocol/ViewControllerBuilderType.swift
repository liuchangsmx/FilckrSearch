//
//  ViewControllerBuilderType.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import UIKit

protocol ViewControllerBuilderType : Storyboardable {
    
    associatedtype T
    var viewModel : T! { get set }
    
}

extension ViewControllerBuilderType {
    static func instantiate(with viewModel : T) -> Self {
        var viewController = UIStoryboard(name: storyboardKey.rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: Self.identify()) as! Self
        viewController.viewModel = viewModel
        return viewController
    }

}
