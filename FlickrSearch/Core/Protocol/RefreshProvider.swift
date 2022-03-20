//
//  RefreshProvider.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import RxSwift
import MJRefresh
import RxCocoa

struct RefreshComponent {
    var pageIndex = 1
    var refreshEnd = ActivityIndicator()
    var noMoreData = PublishSubject<Bool>()
}

protocol HasRefreshComponents : AnyObject, ProtocolComponent {
    var refreshComponent : RefreshComponent {get set}
    func requestData ()
    func refresh ()
    func loadMore ()
}

extension HasRefreshComponents {
    var pageIndex: Int {
        get {
            return refreshComponent.pageIndex
        }
        set {
            refreshComponent.pageIndex = newValue
        }
    }
    var refreshEnd : ActivityIndicator {
        get {
            return refreshComponent.refreshEnd
        }
        set {
            refreshComponent.refreshEnd = newValue
        }
    }
    var noMoreData : PublishSubject<Bool> {
        get {
            return refreshComponent.noMoreData
        }
        set {
            refreshComponent.noMoreData = newValue
        }
    }
}

extension HasRefreshComponents {
    func refresh() {
        pageIndex = 1
        requestData()
    }
    
    func loadMore() {
        pageIndex += 1
        requestData()
    }
}

protocol HasRefreshView {
    var refreshView : UIScrollView { get }
    var header : MJRefreshNormalHeader {get}
    var footer : MJRefreshAutoNormalFooter {get}
}

protocol RefreshProvider : AnyObject, HasRefreshView {
    associatedtype T : HasRefreshComponents
    var viewModel : T! { get set }
}

extension HasRefreshView where Self : UIViewController
{
    var header : MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader()
        header.activityIndicatorViewStyle = .white
        header.stateLabel?.isHidden = true
        header.lastUpdatedTimeLabel?.isHidden = true
        header.arrowView?.image = #imageLiteral(resourceName: "arrow_refresh")
        return header
    }
    
    var footer : MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter()
        return footer
    }
    
}

extension Reactive where Base: UIScrollView {
    
    var refreshEnd: Binder<Bool> {
        return Binder(self.base) { scrollView, loading in
            // 停止加载
            if !loading {
                scrollView.mj_header?.endRefreshing()
                if scrollView.mj_footer != nil && scrollView.mj_footer?.state != .noMoreData {
                    scrollView.mj_footer?.endRefreshing()
                }
            }
        }
    }
    
    var noMoreData: Binder<Bool> {
        return Binder(self.base) { scrollView, end in
            if end {
                scrollView.mj_footer?.state = .noMoreData
            }else {
                scrollView.mj_footer?.state = .idle
            }
        }
    }
}

protocol ListRefreshDataConvertible: Codable {
    associatedtype ListType
    var list : [ListType]? { get }
    var page : Int { get }
    var pages : Int { get }
    var perpage : Int { get }
    var total: Int { get }
}

extension ListRefreshDataConvertible {
    
    func bind(to array: BehaviorRelay<[ListModel<ListType>]>, _ noMoreData: PublishSubject<Bool>, _ loadingCount: BehaviorRelay<Int>? = nil)  {
        if page == 1 {
            array.accept([ListModel(list ?? [])])
        }
        else {
            if array.value.count > 0 {
                var pre = array.value[0]
                pre.items.append(contentsOf: list ?? [])
                array.accept([pre])
            }else {
                array.accept([ListModel(list ?? [])])
            }
        }
        if page >= pages
        {
            noMoreData.onNext(true)
        }else {
            noMoreData.onNext(false)
        }
    }
}
