//
//  Post.swift
//  WavyDisplay
//
//  Created by Aurélie Nouaille-Degorce on 18/06/2019.
//  Copyright © 2019 Nouaille-Degorce. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
