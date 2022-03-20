//
//  CellConfigProtocol.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import UIKit

protocol CellConfigProtocol: IdentifyProtocol {
    associatedtype ItemType
    func configCell(_ item: ItemType, ip : IndexPath)
}

