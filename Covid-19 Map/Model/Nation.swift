//
//  Nation.swift
//  Covid-19 Map
//
//  Created by Emmanuel Tesauro on 02/03/2020.
//  Copyright © 2020 Emmanuel Tesauro. All rights reserved.
//

import SwiftUI

struct Nation: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var confirmedCases: String
    var confirmedDeath: String
    var image: String
}
