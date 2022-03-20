//
//  API_Flickr_List.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation
import Moya

enum API_Flicker {
    /// index: current page number;
    /// search: search keyword
    case search(index: Int, search: String?)
}

extension API_Flicker: TargetType {
    
    var path: String {
        switch self {
        case .search:
            return "services/rest/"
        }
    }
    
    var task: Task {
        switch self {
        case let .search(index, search):
            return .requestParameters(parameters: ["per_page": "30", "page":"\(index)", "text":"\(search ?? "")","method":"flickr.photos.search", "api_key":"6af377dc54798281790fc638f6e4da5e", "format":"json", "nojsoncallback":"1"], encoding: URLEncoding())
            
        }
    }
    
}



// MARK: - List
struct API_Flicker_List: Codable {
    let photos: API_Flicker_List_Photos
    let stat: String
}

// MARK: - Photos
struct API_Flicker_List_Photos: ListRefreshDataConvertible {
    let page, pages, perpage, total: Int
    let photo: [API_Flicker_List_Photos_Photo]
    
    var list: [API_Flicker_List_Photos_Photo]? {
        get {
            return photo
        }
    }
}

// MARK: - Photo
struct API_Flicker_List_Photos_Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
}

extension API_Flicker_List_Photos_Photo {
    var img: String {
        get {
            return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        }
    }
}

