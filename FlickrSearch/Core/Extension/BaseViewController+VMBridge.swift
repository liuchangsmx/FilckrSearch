//
//  BaseViewController+VMBridge.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import RxSwift
import RxCocoa

import Foundation
extension BaseViewController {
    //    MARK:- register protocol
    func registerProtocol(viewModel : ProtocolComponent) {
        if viewModel.component.contains(.refresh) {
            registerRefresh(model: viewModel)
        }
    }
        
    private func registerRefresh(model: ProtocolComponent) {
        let refresh = model as! HasRefreshComponents
        let refreshView = (self as! HasRefreshView).refreshView
        refreshView.mj_header = (self as! HasRefreshView).header
        refreshView.mj_header?.refreshingBlock = {
            refresh.refresh()
        }
        refreshView.mj_footer = (self as! HasRefreshView).footer
        refreshView.mj_footer?.refreshingBlock = {
            refresh.loadMore()
        }
        refresh.refreshEnd.drive(refreshView.rx.refreshEnd).disposed(by: disposeBag)
        refresh.noMoreData.asObserver().bind(to: refreshView.rx.noMoreData).disposed(by: disposeBag)
    }
}
