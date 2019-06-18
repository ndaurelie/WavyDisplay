//
//  Comment.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}
