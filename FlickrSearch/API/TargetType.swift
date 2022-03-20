//
//  TargetType.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Moya

extension TargetType {
    
    var baseURL: URL {
        return URL.lc.base
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
