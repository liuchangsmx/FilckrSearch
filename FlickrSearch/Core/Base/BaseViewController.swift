//
//  BaseViewController.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController, Storyboardable {
    
    class var storyboardKey: StoryboardNameKey {
        return .empty
    }
    
    var disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        createUI()
        binding()
    }
    
    //    MARK:- createUI
    func createUI() { }
    
    //    MARK:- binding
    func binding() { }
    
    //    MARK:- deinit
    deinit {
        #if DEBUG
        print("deinit--\n" + description)
        #endif
    }
    

}
