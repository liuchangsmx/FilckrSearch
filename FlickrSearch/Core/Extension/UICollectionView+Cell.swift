//
//  UICollectionView.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import RxSwift
import RxCocoa

extension UICollectionView {
    func dequeueCell<T: IdentifyProtocol>(_ type: T.Type, ip : IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identify(), for: ip) as! T
    }
    
    func registerNib<T: IdentifyProtocol>(_ nib:T.Type) {
        return register(UINib(nibName: T.identify(), bundle: nil), forCellWithReuseIdentifier: T.identify())
    }
    
    func registerSupplementaryView<T: IdentifyProtocol>(nib: T.Type, kind: String) {
        return register(UINib(nibName: T.identify(), bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identify())
    }
    
    func dequeue<T: CellConfigProtocol>(_ type: T.Type, _ item: T.ItemType, _ ip: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: T.identify(), for: ip) as! T
        cell.configCell(item, ip: ip)
        return cell
    }
}
