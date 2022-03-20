//
//  HistoryCell.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/19.
//

import UIKit

class HistoryCell: UICollectionViewCell, CellConfigProtocol {
    
    //    MARK: - IBOutlet
    
    @IBOutlet weak var lbTitle: UILabel!
    //    MARK: - Variable
    
    //    MARK: - Default
    
    func configCell(_ item: SearchHistory, ip: IndexPath) {
        lbTitle.text = item.text
    }
    
    //    MARK: - Action
    
    //    MARK: - Func
    
}
