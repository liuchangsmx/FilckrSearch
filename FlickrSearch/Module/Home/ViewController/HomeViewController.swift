//
//  HomeViewController.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import RxRealm

class HomeViewController: BaseViewController, RefreshProvider {
    
    override class var storyboardKey: StoryboardNameKey { return .home }

    //    MARK: - IBOutlet

    @IBOutlet weak var viHistory: UIView!
    @IBOutlet weak var cvHistory: UICollectionView! {
        didSet {
            cvHistory.contentInset.left = 12
            cvHistory.contentInset.right = 12
        }
    }
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btStyle: UIButton!
    @IBOutlet weak var btDelete: UIButton!
    //    MARK: - Variable
    
    var viewModel: HomeViewModel! = HomeViewModel()
    var refreshView: UIScrollView { return collectionView }

    // datasource for search result
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<ListModel<API_Flicker_List_Photos_Photo>>(configureCell: { ds, cv, ip, item in
        return cv.dequeue(SearchCell.self, item, ip)
    })
    // datasource for search history
    private lazy var historyDataSource = RxCollectionViewSectionedReloadDataSource<ListModel<SearchHistory>>(configureCell: { ds, cv, ip, item in
        return cv.dequeue(HistoryCell.self, item, ip)
    })

    
    //    MARK: - Default
    override func createUI() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        navigationItem.titleView = searchBar
        navigationItem.setRightBarButton(UIBarButtonItem(customView: btStyle), animated: false)
    }

    override func binding() {

        /// CollectionView
        viewModel.array.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        /// Search History
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                let userInfo = notification.userInfo
                self?.cvHistory.contentInset.bottom = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                self?.viHistory.isHidden = false
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.viHistory.isHidden = true
            }).disposed(by: disposeBag)
        /// Serarch Bar
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
            if let text = self.searchBar.text, text.count > 0 {
                self.viewModel.refresh()
                self.searchBar.resignFirstResponder()
                self.viewModel.saveSearchHistory(with: text)
            }
        }).disposed(by: disposeBag)
        // longth limit 10
        searchBar.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            if let text = self?.searchBar.text {
                self?.searchBar.text = String(text.prefix(10))
            }
        }).disposed(by: disposeBag)
        searchBar.rx.text.orEmpty.bind(to: viewModel.search).disposed(by: disposeBag)
        /// search history collectionView
        cvHistory.rx.setDelegate(self).disposed(by: disposeBag)
        Observable.array(from: viewModel.history).map({ results in
            var array: [SearchHistory] = []
            results.forEach { search in
                array.append(search)
            }
            return [ListModel(array)]
        }).bind(to: cvHistory.rx.items(dataSource: historyDataSource)).disposed(by: disposeBag)
        /// grid <-> list
        btStyle.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.changeStyle()
        }).disposed(by: disposeBag)
        viewModel.listStyle.subscribe(onNext: { [weak self] style in
            self?.btStyle.setImage(style ? #imageLiteral(resourceName: "grid") : #imageLiteral(resourceName:"list"), for: .normal)
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        /// delete history
        btDelete.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.deleteSearchHistory()
        }).disposed(by: disposeBag)
        
        registerProtocol(viewModel: viewModel)
    }
    //    MARK: - Action

    //    MARK: - Func
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UISearchBarDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            if viewModel.listStyle.value {
                return CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH*0.6)
            } else {
                return CGSize(width: SCREEN_WIDTH/3, height: SCREEN_WIDTH/3)
            }
        } else {
            let maxSize = CGSize(width: SCREEN_WIDTH-24, height: 36)
            let text = historyDataSource[indexPath].text
            let width = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil).width
            return CGSize(width: width + 24, height: 36)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.cvHistory {
            let text = historyDataSource[indexPath].text
            searchBar.text = text
            viewModel.search.accept(text)
            viewModel.refresh()
            searchBar.resignFirstResponder()
            viHistory.isHidden = true
        }
    }
}
