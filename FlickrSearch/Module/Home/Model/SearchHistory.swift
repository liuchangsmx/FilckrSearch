//
//  SearchHistory.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/19.
//

import Foundation
import RealmSwift

class SearchHistory: Object {
    @Persisted var text = ""
}
