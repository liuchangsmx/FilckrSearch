//
//  URL.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import Foundation

extension String {
    var url: URL? {
        if self.hasPrefix("http") {
            return URL(string: self)
        }
        else {
            let string = "http://\(self)"
            return URL(string: string)
        }
    }
}

extension Data {
    
    static func sampleData(from docName: String) -> Data {
        let fileURL = Bundle.main.url(forResource: docName, withExtension: nil)
        return try! Data.init(contentsOf: fileURL!)
    }

}

extension URL: Extensionable {
    
}

extension LCExtension where Base == URL {
    

    static let base: URL = {
        return "https://api.flickr.com/".url!
    }()

}
