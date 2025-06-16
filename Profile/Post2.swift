//
//  Post.swift
//  Navigation
//
//  Created by Лисин Никита on 09.06.2025.
//

import Foundation

import UIKit

 struct Post2 {
    let author: String
    let description: String
    let image: String
    var likes: Int
    var views: Int
    
    init(author: String, description: String, image: String, likes: Int = 0, views: Int = 0) {
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}

