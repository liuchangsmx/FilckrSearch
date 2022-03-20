//
//  SearchCell.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import UIKit
import SDWebImage
import Moya

class SearchCell: UICollectionViewCell, CellConfigProtocol {
    
    //    MARK: - IBOutlet
    
    @IBOutlet weak var ivSearch: UIImageView!
    //    MARK: - Variable
    
    //    MARK: - Default
    
    func configCell(_ item: API_Flicker_List_Photos_Photo, ip: IndexPath) {
        ivSearch.sd_setImage(with: item.img.url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    //    MARK: - Action
    
    //    MARK: - Func
    
}


