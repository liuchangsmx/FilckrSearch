//
//  ListModel.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import RxDataSources

struct ListModel<ItemType> {
    public var items: [Item]
    
    public init(_ items: [Item]) {
        self.items = items
    }
}

extension ListModel: SectionModelType {
    
    public typealias Item = ItemType
    
    public init(original: ListModel<Item>, items: [Item]) {
        self.items = items
    }
}
