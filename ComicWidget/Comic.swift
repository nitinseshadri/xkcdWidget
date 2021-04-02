//
//  Comic.swift
//  xkcdWidget
//
//  Created by Nitin Seshadri on 3/15/21.
//

import Foundation
import UIKit

struct Comic: Codable {
    var num: Int
    var title: String
    var img: String
    
    var uiImage: UIImage {
        get {
            UIImage(data: try! Data(contentsOf: URL(string: img)!))!
        }
    }
}
    
class ComicController: NSObject {
    let url = URL(string: "https://xkcd.com/info.0.json")!
    static let shared = ComicController()
    
    func getComic(completion: @escaping(Comic)->Void) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let comic = try! JSONDecoder().decode(Comic.self, from: data)
            completion(comic)
        }
        
        task.resume()
    }
}
