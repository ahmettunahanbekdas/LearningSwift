//
//  Post.swift
//  Project 20- APIexample
//
//  Created by Ahmet Tunahan Bekdaş on 2.12.2023.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    
}
