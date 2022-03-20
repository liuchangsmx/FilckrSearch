//
//  HomeViewModel.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewModel: HasRefreshComponents {
    
    /// network provider
    var provider = MoyaProvider<API_Flicker>()
    ///  home viewcontroller - collectionview style
    var listStyle = BehaviorRelay<Bool>(value: true)
    ///  search key  text
    var search = BehaviorRelay<String>(value: "")
    /// datasource for home viewcontroller - collectionview
    var array: BehaviorRelay<[ListModel<API_Flicker_List_Photos_Photo>]> = BehaviorRelay(value: [])
    /// database
    let realm = try! Realm()
    let history: Results<SearchHistory>
    /// default
    var refreshComponent = RefreshComponent()
    let disposeBag = DisposeBag()

    init() {
        history = realm.objects(SearchHistory.self)
    }

    func requestData() {
        provider.rx.request(.search(index: pageIndex, search: search.value))
            .trackActivity(refreshEnd)
            .map(API_Flicker_List.self)
            .subscribe(onNext: { [weak self] res in
                if let self = self, res.stat == "ok" {
                    res.photos.bind(to: self.array, self.noMoreData)
                }
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    /// change  home viewcontroller - collectionview style
    func changeStyle() {
        listStyle.accept(!listStyle.value)
    }
    
    func saveSearchHistory(with text: String) {
        let history = SearchHistory()
        history.text = text
        let realm = try! Realm()
        try! realm.write {
          realm.add(history)
        }
    }
    
    func deleteSearchHistory() {
        let items = realm.objects(SearchHistory.self)
        try! realm.write {
            realm.delete(items)
        }
    }
    
}
